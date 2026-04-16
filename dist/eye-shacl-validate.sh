#!/bin/bash

dir=$(dirname $0)
validate="$dir/validate.n3"
report="$dir/report.n3"

# todo: replace with eyeling
# eye --nope --quiet --query $report $validate $1 --turtle $2 

# trim prefix file:// from $1 and $2
file1=$(echo $1 | sed 's|^file://||')
file2=$(echo $2 | sed 's|^file://||')

cat $report $validate $file1 $file2 | npx eyeling