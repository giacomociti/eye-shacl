#!/bin/bash

dir=$(dirname $0)
compile="$dir/compile.n3"
imports="$dir/imports.n3"

eye --nope --quiet --pass-only-new $compile <(eye --nope --quiet --no-qvars --pass $imports --turtle $1)
