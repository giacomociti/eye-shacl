import fs from 'fs'
import n3 from 'n3';
import path from 'path';
import eyeling from 'eyeling';
import oxigraph from 'oxigraph';

const __dirname = path.dirname(new URL(import.meta.url).pathname);

const rules = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'shapes.json'), 'utf8'))

async function compile(shapesFile) {
   
    const shapesData = fs.readFileSync(shapesFile, 'utf8')
    const quads = new n3.Parser().parse(shapesData)
    const result = new Map()

    const streamResult = eyeling.reasonStream({ quads, rules })
    for (const triple of streamResult.derived) {
        if (triple.fact.p.value === 'http://eye-shacl#sparql') {
            const query = JSON.parse(triple.fact.o.value)
            result.set(triple.fact.s.value ?? triple.fact.s.label.slice(2), query)
        }
    }
    return result
}

function validate(dataFile, queries) {
    const data = fs.readFileSync(dataFile, 'utf8')
    const dataTriples = new n3.Parser({  baseIRI: `file://${path.resolve(dataFile)}` }).parse(data)
    const store = new oxigraph.Store()
    
    for (const triple of dataTriples) {
       store.add(triple)
    }

    // run queries and collect validation results
    const writer = new n3.Writer(process.stdout, { format: 'Turtle' , prefixes: {
        sh: 'http://www.w3.org/ns/shacl#',
        xsd: 'http://www.w3.org/2001/XMLSchema#',
    }})
    const report = n3.DataFactory.blankNode()
    const rdfType = n3.DataFactory.namedNode('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
    writer.addQuad(report, rdfType, n3.DataFactory.namedNode('http://www.w3.org/ns/shacl#ValidationReport'))
    let conforms = true
    for (const [ shapeIRI, query ] of queries) {
        // console.log(`Validating shape ${shapeIRI}`)
        const sparqlResult = store.query(query)
        if (sparqlResult.length === 0) {
            continue
        }
        conforms = false
        for (const quad of sparqlResult) {
            if (quad.predicate.equals(rdfType) && quad.object.equals(n3.DataFactory.namedNode('http://www.w3.org/ns/shacl#ValidationResult'))) {
                writer.addQuad(report, n3.DataFactory.namedNode('http://www.w3.org/ns/shacl#result'), quad.subject)
            }
            writer.addQuad(quad.subject, quad.predicate, quad.object)
        }   
    }

    
    writer.addQuad(report, n3.DataFactory.namedNode('http://www.w3.org/ns/shacl#conforms'), n3.DataFactory.literal(conforms.toString(), n3.DataFactory.namedNode('http://www.w3.org/2001/XMLSchema#boolean')))

    writer.end()
}

async function main([shapesFile, dataFile, outputDirectory]) {
    if (shapesFile.startsWith('file://')) {
        shapesFile = shapesFile.replace('file://', '')
    }
    if (dataFile.startsWith('file://')) {
        dataFile = dataFile.replace('file://', '')
    }
    const queries = await compile(shapesFile)
    if (outputDirectory) {
        saveQueries(queries, outputDirectory)
    }
    validate(dataFile, queries)
}

function saveQueries(queries, outputDirectory) {
    for (const [ shapeIRI, query ] of queries) {
        console.log(`# Compiled shape ${shapeIRI}`)
        const shape = shapeIRI.split('/').pop()
        fs.writeFileSync(`${outputDirectory}/${shape}.rq`, query)
    }
    // write a JSON file (SPARQL notebook) listing file names
    const notebook = []
    for (const shapeIRI of queries.keys()) {
        const shape = shapeIRI.split('/').pop()
        notebook.push({ 
            kind: 2,
            language: "sparql",
            value: "",
            metadata: {
                file: `${shape}.rq`
            }
        })
    }
    fs.writeFileSync(`${outputDirectory}/shapes.sparqlbook`, JSON.stringify(notebook, null, 2))
}


const command = process.argv[2]
switch (command) {
    case 'main':
        await main(process.argv.slice(3))
    break
    case 'compile':
        const [ shapesFile, outputDirectory ] = process.argv.slice(3)
        const queries = await compile(shapesFile, outputDirectory)
        saveQueries(queries, outputDirectory)
    break

    case 'validate':
        const [ dataFile, directory ] = process.argv.slice(3)
        const queryMap = new Map()
        fs.readdirSync(directory).forEach(file => {     
            queryMap.set(file.replace('.rq',''), fs.readFileSync(path.join(directory, file), 'utf8'))
        })
        validate(dataFile, queryMap)
    break

    default:
        console.log('Usage: node index.js compile <shapesFile> <outputDirectory> | validate <dataFile> <directory>')
        process.exit(1)
}

