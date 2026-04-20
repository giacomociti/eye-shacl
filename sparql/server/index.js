import fs from 'fs';
import path from 'path';
import n3 from 'n3';
import express from 'express';
import eyeling from 'eyeling';
import SparqlClient from 'sparql-http-client'

const __dirname = path.dirname(new URL(import.meta.url).pathname);
const rules = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'shapes.json'), 'utf8'))

const PORT = process.env.PORT || 3000;

let SPARQL_ENDPOINT = process.env.SPARQL_ENDPOINT;
// Allow override via command-line argument: node index.js http://example.org/sparql
if (!SPARQL_ENDPOINT && process.argv[2]) {
	SPARQL_ENDPOINT = process.argv[2];
}
if (!SPARQL_ENDPOINT) {
	throw new Error('SPARQL_ENDPOINT not set. Set via env or as argument.');
}


function getRawBody(req) {
	return new Promise((resolve, reject) => {
		let chunks = [];
		req.on('data', chunk => chunks.push(chunk));
		req.on('end', () => resolve(Buffer.concat(chunks).toString()));
		req.on('error', reject);
	});
}

const generateSPARQLQueries = (quads) => {
	const queries = []
	const streamResult = eyeling.reasonStream({quads, rules})
	for (const triple of streamResult.derived) {
		if (triple.fact.p.value === 'http://eye-shacl#sparql') {
			const query = JSON.parse(triple.fact.o.value)
			queries.push(query)
		}
	}
	return queries;
}

const executeSPARQLQueries = async (queries, responseStream) => {
	const writer = new n3.Writer(responseStream, { 
		format: 'Turtle', 
		prefixes: {
			sh: 'http://www.w3.org/ns/shacl#',
			xsd: 'http://www.w3.org/2001/XMLSchema#',
		} 
	});
	const client = new SparqlClient({ endpointUrl: SPARQL_ENDPOINT });
	

	const [ 
		rdfType, 
		shaclResult,
		shaclConforms,
		shaclValidationReport,
		shaclValidationResult,
		xsdBoolean
	] = [
		'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', 
		'http://www.w3.org/ns/shacl#result',
		'http://www.w3.org/ns/shacl#conforms',
		'http://www.w3.org/ns/shacl#ValidationReport', 
		'http://www.w3.org/ns/shacl#ValidationResult',
		'http://www.w3.org/2001/XMLSchema#boolean'
		
	].map(x => n3.DataFactory.namedNode(x))

	const report = n3.DataFactory.blankNode()
	writer.addQuad(report, rdfType, shaclValidationReport)
	let resultsCount = 0
	for (const query of queries) {
		const quadStream = client.query.construct(query, { operation: 'postDirect' });
		for await (const quad of quadStream) {
			if (quad.predicate.equals(rdfType) && quad.object.equals(shaclValidationResult)) {
				resultsCount++;
				writer.addQuad(report, shaclResult, quad.subject)
			}
			writer.addQuad(quad);
		}
	}
	console.log(`Executed ${queries.length} queries, found ${resultsCount} validation results`);
	const conforms = n3.DataFactory.literal((resultsCount===0).toString(), xsdBoolean)
	writer.addQuad(report, shaclConforms, conforms)
	writer.end();
}

const app = express();

app.post('/shacl', async (req, res) => {
	try {
		const input = await getRawBody(req);
		const quads = new n3.Parser().parse(input);
		const queries = generateSPARQLQueries(quads);
		res.set('Content-Type', 'text/turtle');
		await executeSPARQLQueries(queries, res);
		
	} catch (err) {
		console.error('Error processing request:', err);
		res.status(500).send('Error processing request');
	}
});

app.listen(PORT, () => {
	console.log(`SHACL server listening on port ${PORT}`);
	console.log(`Using SPARQL endpoint: ${SPARQL_ENDPOINT}`);
});
