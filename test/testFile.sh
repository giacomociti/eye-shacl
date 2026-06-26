#!/bin/sh

npm run --silent test:expected $1 > test-expected.ttl

npm run --silent test:create $1 | sh > test-actual.ttl

npm run --silent test:actual test-actual.ttl > test-actual-report.ttl

npm run --silent test:check | grep 'isomorphic' | wc -l