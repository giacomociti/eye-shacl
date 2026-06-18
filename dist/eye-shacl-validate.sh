#!/bin/bash

dir=$(dirname $0)
validate="$dir/validate.n3"
# report="$dir/report.n3"

npx eyeling $validate $1 $2