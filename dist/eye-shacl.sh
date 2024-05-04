#!/bin/bash

dir=$(dirname $0)
compile="$dir/eye-shacl-compile.sh"
validate="$dir/eye-shacl-validate.sh"

$validate <($compile $1) $2