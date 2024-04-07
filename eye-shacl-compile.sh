#!/bin/bash
eye --nope --quiet --pass-only-new rules/compile/*.n3 <(eye --nope --quiet --no-qvars --pass $1)
