#!/bin/sh
swipl -x eye-shacl.pvm --nope --quiet --query report.n3 "$@" 2>/dev/null