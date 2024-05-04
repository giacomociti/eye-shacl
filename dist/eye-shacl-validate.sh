#!/bin/bash

dir=$(dirname $0)
validate="$dir/validate.n3"
shapesGraph="$dir/shapesGraph.n3"

eye --nope --quiet --pass-only-new $validate $shapesGraph $1 --turtle $2 