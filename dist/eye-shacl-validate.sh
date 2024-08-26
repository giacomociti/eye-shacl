#!/bin/bash

dir=$(dirname $0)
validate="$dir/validate.n3"
report="$dir/report.n3"

eye --nope --quiet --query $report $validate $1 --turtle $2 