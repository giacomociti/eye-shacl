
eye --nope --quiet --query prepare.n3 $1  --output test-input.ttl
eye --nope --quiet --query ../../report.n3 ../../rules/report-path.n3 $1 --output test-expected.ttl
swipl -x ../../eye-shacl.pvm --nope --quiet --query ../../report.n3 --turtle test-input.ttl --output test-actual.ttl 2>/dev/null
eye --nope --quiet --pass-only-new check.n3 --turtle test-input.ttl --output test-result.ttl