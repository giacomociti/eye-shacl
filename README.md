# eye-shacl

A [SHACL](https://www.w3.org/TR/shacl/) implementation using [Notation-3](https://notation3.org/) rules. 

It works with the [eyeling](https://github.com/eyereasoner/eyeling) reasoner and with the [eye](https://github.com/eyereasoner/eye) reasoner.

### Usage with eyeling

Call `eyeling` passing the rules [eye-shacl.n3](https://raw.githubusercontent.com/giacomociti/eye-shacl/refs/heads/main/rules/eye-shacl.n3), the shapes and the data to validate.

The following is a validation example from the SHACL test suite ([personexample.ttl](https://raw.githubusercontent.com/w3c/data-shapes/gh-pages/data-shapes-test-suite/tests/core/complex/personexample.ttl) includes shapes and data)

```bash
npx eyeling \
https://raw.githubusercontent.com/giacomociti/eye-shacl/refs/heads/main/rules/eye-shacl.n3 \
https://raw.githubusercontent.com/w3c/data-shapes/gh-pages/data-shapes-test-suite/tests/core/complex/personexample.ttl
```

URLs for input are handy, but usually local files are preferred.


### Usage with eye

Call `eye` passing the same arguments as above:

```bash
eye --nope --quiet --pass-only-new \
https://raw.githubusercontent.com/giacomociti/eye-shacl/refs/heads/main/rules/eye-shacl.n3 \
https://raw.githubusercontent.com/w3c/data-shapes/gh-pages/data-shapes-test-suite/tests/core/complex/personexample.ttl
```
