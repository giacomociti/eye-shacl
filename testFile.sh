#!/bin/sh

eye --nope --quiet --query report.n3 report-path.n3 $1 --output test-expected.ttl
eye --nope --quiet testFile.n3 $1 --pass-only-new
eye --nope --quiet --query report.n3 report-path.n3 test-actual.ttl > test-actual-report.ttl
eye --nope --quiet --pass check.n3 | grep 'isomorphic' | wc -l