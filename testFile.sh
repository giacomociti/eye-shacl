#!/bin/sh

eye --nope --quiet --query report.n3 $1 --output test-expected.ttl
eye --nope --quiet testFile.n3 $1 --pass-only-new
eye --nope --quiet test-actual.ttl --entail test-expected.ttl | grep 'true.' | wc -l
