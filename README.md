# eye-shacl

A [SHACL](https://www.w3.org/TR/shacl/) implementation using the [EYE](https://eyereasoner.github.io/eye/) reasoner.

### Installation
[Install](https://github.com/eyereasoner/eye?tab=readme-ov-file#installation) the eye reasoner, download the [dist](/dist) folder and use the bash scripts like in the following examples.

### Usage
```bash
# validate data.ttl against shapes.ttl
./eye-shacl.sh shapes.ttl data.ttl
```

Since the shapes are first compiled into rules, you can compile them once:
```bash
./eye-shacl-compile.sh shapes.ttl > shapes.n3
```

and reuse multiple times:
```bash
./eye-shacl-validate.sh shapes.n3 data1.ttl
./eye-shacl-validate.sh shapes.n3 data2.ttl
```

Online resources are allowed as input, like in the following example from the official test suite:
```bash
./eye-shacl.sh \
https://raw.githubusercontent.com/w3c/data-shapes/gh-pages/data-shapes-test-suite/tests/core/complex/personexample.ttl \
https://raw.githubusercontent.com/w3c/data-shapes/gh-pages/data-shapes-test-suite/tests/core/complex/personexample.ttl
```


### To do
- improve tests (clone result path as required by the test suite)
- add sh:details
- replace skolem IRIs in sh:sourceShape

### Known issues
- parsing of ill-typed literals (see test core/node/datatype-001.ttl)
- sh:flags is ignored (see test core/node/pattern-002.ttl)
- date offset (see test core/node/minInclusive-003.ttl)