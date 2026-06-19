#!/bin/sh

eye --nope --quiet --query report-expected.n3 ../rules/compile/cbd.n3 --turtle $1 --output test-expected.ttl
# eye --nope --quiet --strings testFile.n3 $1 | sh > test-actual.ttl
npx eyeling testFile.n3 $1 | sh > test-actual.ttl
eye --nope --quiet --query report-actual.n3 path-split.n3 test-actual.ttl --output test-actual-report.ttl
# eye --nope --quiet --pass check.n3 | grep 'isomorphic' | wc -l
npx eyeling check.n3 | grep 'isomorphic' | wc -l