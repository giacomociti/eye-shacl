# Validation

note: in the following RDF snippets we assume the namespaces:

```turtle
@prefix ex: <http:/example.org/> .
@prefix sh: <http://www.w3.org/ns/shacl#> .
@prefix this: <http://eye-shacl#> .
```
where `this:` is the namespace associated with this library.

To validate data against shapes, we first create validation rules from shapes (using [compilation](./rules//compile/) rules to generate other rules) and then we validate the data using the generated rules (as well as generic [runtime](./rules/validate/) ones).

## compilation

The compilation phase converts shapes into rules.

A preliminary Skolemization step (calling `eye` with option `--no-qvars`) prevents blank nodes in shapes from being interpreted as variables in the corresponding rules created.

Rules are created for constraints and target declarations found in the shapes graph.

### targets
From target declarations, we create rules to derive focus nodes. For example:
```turtle
ex:shape sh:targetClass ex:Class
``` 

yields the rule:

```
{ 
    ex:shape this:focusNode ?U_10.
} <= {
    ?U_10 this:class ex:Class.
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
    ex:shape this:focusNode ?U_11.
    ?U_12 log:notIncludes {
        ?U_11 this:nodeKind sh:IRI.
    }.
    <http://eye-shacl#> this:report ?U_13.
} => {
    ?U_13 sh:result ?U_14.
    ?U_14 a sh:ValidationResult.
    ?U_14 sh:sourceConstraintComponent sh:NodeKindConstraintComponent.
    ?U_14 sh:sourceShape ex:shape.
    ?U_14 sh:focusNode ?U_11.
    ?U_14 sh:value ?U_11.
}.
```
where the predicate `this:nodeKind` is defined in the runtime rules.
Evaluating the rule involves looking for focus nodes,
and checking whether they satisfy the constraint, otherwise creating validation results.

For the same constraint, we may also need a backward rule:

```turtle
{
    ?U_15 this:violates ex:shape.
} <= {
    ?U_16 log:notIncludes {
        ?U_15 this:nodeKind sh:IRI.
    }.
}.
```

When the shape is part of a [Shape-based Constraint Components](https://www.w3.org/TR/shacl/#core-components-shape) like `sh:not`, `sh:or`..., the backward rule determines the presence of violations without collecting results.