#!/bin/sh

# eye --nope --quiet --query report-expected.n3 ../rules/compile/cbd.n3 --turtle $1 --output test-expected.ttl
# eye --nope --quiet testFile-sparql.n3 $1 --pass-only-new
# eye --nope --quiet --query report-actual.n3 path-split.n3 test-actual.ttl --output test-actual-report.ttl
# eye --nope --quiet --pass check.n3 | grep 'isomorphic' | wc -l

npm run --silent test:expected $1 > test-expected.ttl

npm run --silent test:create-sparql $1 | sh > test-actual.ttl

npm run --silent test:actual test-actual.ttl > test-actual-report.ttl

npm run --silent test:check | grep 'isomorphic' | wc -l