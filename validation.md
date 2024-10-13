# Validation
Using rules to implement RDF validation is endorsed in academic literature, see ["RDF graph validation using rule-based reasoning"](https://www.researchgate.net/publication/347222046_RDF_graph_validation_using_rule-based_reasoning).
The ideas of leveraging skolemization and rule-producing rules come from Chapter 6 of the PhD thesis of Dörthe Arndt: ["Notation3 as the Unifying Logic for the Semantic Web"](https://biblio.ugent.be/publication/8634507).

Note: in the following snippets we assume the namespaces:

```turtle
@prefix ex: <http:/example.org/> .
@prefix sh: <http://www.w3.org/ns/shacl#> .
@prefix this: <http://eye-shacl#> .
```
where `this:` is the namespace associated with this library.

To validate data against shapes, we first create validation rules from shapes (using [compilation](./rules//compile/) rules) and then we validate the data using the generated rules (as well as generic [runtime](./rules/validate/) ones).

## compilation

The compilation phase converts shapes into rules.

A preliminary skolemization step (calling `eye` with option `--no-qvars`) prevents blank nodes in shapes from being interpreted as variables in the rules created.

Rules are created for constraints and target declarations found in the shapes graph.

### targets
From target declarations, we create rules to derive focus nodes. For example:
```turtle
ex:shape sh:targetClass ex:Class
``` 
yields the rule:

```
{ 
    ex:shape this:focusNode ?focusNode.
} <= {
    ?focusNode this:class ex:Class.
}.
```
where the predicate `this:class` is defined by the following runtime rules (available only during data validation):

```
{ ?value this:class ?class } <= { ?value a ?class } .
{ ?value this:class ?class } <= { ?subclass rdfs:subClassOf ?class . ?value this:class ?subclass } .
```

### constraints

From shape constraints, we create rules to derive violations. For example:

```turtle
ex:shape sh:nodeKind sh:IRI 
```
yields the rule:

```
{
    ex:shape this:focusNode ?focusNode.
    ?scope log:notIncludes {
        ?focusNode this:nodeKind sh:IRI.
    }.
    this: this:report ?report.
} => {
    ?report sh:result [
        a sh:ValidationResult.
        sh:sourceConstraintComponent sh:NodeKindConstraintComponent.
        sh:sourceShape ex:shape.
        sh:focusNode ?focusNode.
        sh:value ?focusNode.
    ]
}.
```
where the predicate `this:nodeKind` is defined in the runtime rules.
Evaluating the rule involves looking for focus nodes,
and checking whether they satisfy the constraint, otherwise creating validation results.

For the same constraint, we may also need a backward rule:

```turtle
{
    ?node this:violates ex:shape.
} <= {
    ?scope log:notIncludes {
        ?node this:nodeKind sh:IRI.
    }.
}.
```

When the shape is part of another shape (as with logical constraints `sh:or`, `sh:not` etc.), the backward rule determines the presence of violations without collecting results.

### paths
For property shapes:
```turtle
ex:propertyShape sh:path ex:name ; sh:nodeKind sh:Literal .
```
there is also a path traversal with the predicate `this:value` 
deriving the values reached following the path from a focus node.:
```turtle
{
    ex:propertyShape this:focusNode ?focusNode.

    (?focusNode ex:name) this:value ?value .

    ?scope log:notIncludes {
        ?focusNode this:nodeKind sh:Literal.
    }.
    this: this:report ?report.
} => {
    ?report sh:result [
        a sh:ValidationResult.
        sh:sourceConstraintComponent sh:NodeKindConstraintComponent.
        sh:sourceShape ex:propertyShape.
        sh:focusNode ?focusNode.
        sh:value ?value.
    ]
}.
```
For predicate paths (like `ex:name` in this example)
there is a straightforward implementation with a generic runtime rule:

```turtle
{ 
    (?focusNode ?path) this:value ?value 
} <= { 
    ?focusNode ?path ?value
} .
```


For complex paths (with `sh:inversePath`, `sh:alternativePath` etc.):

```turtle
ex:propertyShape sh:path [ sh:inversePath ex:name ]
```
we need to generate
additional specific rules during compilation:
```turtle
{
    (?node skolem:node1) this:value ?value .
} <= {
    (?value ex:name) this:value ?node .
} .
```

where `skolem:node1` is the skolem IRI for the path blank node. This example also shows the need for the preliminary skolemization step: a blank node in place of
the skolem IRI would be treated as a
logical variable instead of referring to the path node.
