#!/bin/bash

dir=$(dirname $0)
validate="$dir/validate.n3"
# report="$dir/report.n3"

# trim prefix file:// from $1 and $2
file1=$(echo $1 | sed 's|^file://||')
file2=$(echo $2 | sed 's|^file://||')

npx eyeling $validate $file1 $file2