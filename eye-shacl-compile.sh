#!/bin/bash
eye --nope --quiet --pass-only-new rules/compile/*.n3 <(eye --nope --quiet --no-qvars --pass rules/imports.n3 --turtle $1)
