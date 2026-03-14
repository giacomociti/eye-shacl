## SHACL validation with SPARQL

Convert SHACL shapes into SPARQL queries for validation.

For example, the following shape:

```turtle
@prefix ex: <http://example.org/> .
@prefix sh: <http://www.w3.org/ns/shacl#> .

ex:shape sh:targetClass ex:Class ;
sh:nodeKind sh:IRI .
```

is converted to the query:

```sparql
PREFIX sh: <http://www.w3.org/ns/shacl#>    
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    
CONSTRUCT {
    ?validationResult a sh:ValidationResult ;
        sh:resultSeverity <http://www.w3.org/ns/shacl#Violation> ;
        sh:sourceShape <http://example.org/shape> ;
        sh:sourceConstraintComponent ?sourceConstraintComponent ;
        sh:focusNode ?focusNode ;
        sh:value ?value ;
        sh:resultMessage ?resultMessage .   
}
WHERE {

    {
        ?focusNode rdf:type/rdfs:subClassOf* <http://example.org/Class> .
        BIND(?focusNode AS ?value)
        BIND(?value AS ?x)

        FILTER (!isIRI(?x))

        BIND(BNODE() AS ?validationResult)
        BIND(<http://www.w3.org/ns/shacl#NodeKindConstraintComponent> AS ?sourceConstraintComponent) 
        BIND("value should be an IRI" AS ?resultMessage)
    }
    
}
```

The conversion is implemented with N3 rules [shapes.n3](shapes.n3).

### Test


In the [test](./test/) directory there is a NodeJS helper project.
Move to that directory and run `npm install`. Then you can reproduce
the example above:

```sh
node index.js compile ../../test/custom/test01.ttl ./output/
```

In the [output](./test/output/) directory you will find a file with the generated
query and also a SPARQL notebook referencing it.


### Test cases

The [test](../test/) directory of the repo contains scripts and test data,
including the official SHACL test suite. If you move to that directory
you can run all the tests:

```sh
./test-sparql.sh
```

you can also run a single test:

```sh
./testFile-sparql.sh core/node/and-001.ttl
```

Tests perform validation generating queries and running them using an in-memory Oxigraph dataset.
The outcome is determined comparing the contents of `test-expected.ttl` and `test-actual.ttl`.

Once in a while, you may want to clean up the output folder, keeping only the `.gitignore` file
```sh
find ../sparql/test/output -type f ! -name '.gitignore' -delete
```







