# eye-shacl

A [SHACL](https://www.w3.org/TR/shacl/) implementation using the [eyeling](https://github.com/eyereasoner/eyeling) reasoner.


### Usage

Call `eyeling` passing the [eye-shacl rules](https://raw.githubusercontent.com/giacomociti/eye-shacl/refs/heads/eyeling/rules/eye-shacl.n3), the shapes and the data to validate.

The following is a validation example from the SHACL test suite (`personexample.ttl` includes shapes and data)

```bash
npx eyeling \
https://raw.githubusercontent.com/giacomociti/eye-shacl/refs/heads/eyeling/rules/eye-shacl.n3 \
https://raw.githubusercontent.com/w3c/data-shapes/gh-pages/data-shapes-test-suite/tests/core/complex/personexample.ttl
```
