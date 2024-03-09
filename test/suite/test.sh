#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NORMAL="\e[0;39m"

OK=0
FAILED=0

echo -e "${YELLOW}-------------------${NORMAL}"
echo -e "${YELLOW}Running test${NORMAL}"
echo -e "${YELLOW}-------------------${NORMAL}"
echo ""

# https://github.com/w3c/data-shapes/tree/gh-pages/data-shapes-test-suite/tests/core
files=(
    "core/complex/personexample.ttl"
    # "core/complex/shacl-shacl.ttl" # timeout

    "core/misc/deactivated-001.ttl"
    "core/misc/deactivated-002.ttl"
    "core/misc/message-001.ttl"
    "core/misc/severity-001.ttl"
    "core/misc/severity-002.ttl"

    "core/node/and-001.ttl"
    "core/node/and-002.ttl"
    "core/node/class-001.ttl"
    "core/node/class-002.ttl"
    "core/node/closed-001.ttl"
    "core/node/closed-002.ttl"
    "core/node/datatype-001.ttl" # parsing error
    "core/node/datatype-002.ttl"
    "core/node/disjoint-001.ttl"
    "core/node/equals-001.ttl"
    "core/node/and-001.ttl"
    "core/node/hasValue-001.ttl"
    "core/node/in-001.ttl"
    "core/node/languageIn-001.ttl"
    "core/node/maxExclusive-001.ttl"
    "core/node/maxInclusive-001.ttl"
    "core/node/maxLength-001.ttl"
    "core/node/minExclusive-001.ttl"
    "core/node/minInclusive-001.ttl"
    "core/node/minInclusive-002.ttl"
    "core/node/minInclusive-003.ttl" # date offset
    "core/node/minLength-001.ttl"
    "core/node/node-001.ttl" # detail
    "core/node/nodeKind-001.ttl"
    "core/node/not-001.ttl"
    "core/node/not-002.ttl"
    "core/node/or-001.ttl"
    "core/node/pattern-001.ttl"
    "core/node/pattern-002.ttl" # flag?
    "core/node/qualified-001.ttl"
    "core/node/xone-001.ttl" # todo
    "core/node/xone-duplicate.ttl" #todo

    "core/path/path-alternative-001.ttl" # shared result path
    "core/path/path-complex-001.ttl" # shared result path
    "core/path/path-complex-002.ttl" # shared result path
    "core/path/path-inverse-001.ttl" # shared result path
    "core/path/path-oneOrMore-001.ttl" # shared result path
    "core/path/path-sequence-001.ttl"
    "core/path/path-sequence-002.ttl"
    "core/path/path-sequence-duplicate-001.ttl" 
    # "core/path/path-strange-001.ttl" # shoud be skipped (https://github.com/w3c/issues/124)
    # "core/path/path-strange-002.ttl" # shoud be skipped (https://github.com/w3c/issues/124)
    "core/path/path-unused-001.ttl"
    "core/path/path-zeroOrMore-001.ttl"
    "core/path/path-zeroOrOne-001.ttl"

    "core/property/and-001.ttl"
    "core/property/class-001.ttl"
    "core/property/datatype-001.ttl"
    "core/property/datatype-002.ttl"
    "core/property/datatype-003.ttl"
    "core/property/datatype-ill-formed.ttl" # missing results
    "core/property/disjoint-001.ttl"
    "core/property/equals-001.ttl" # fails
    "core/property/hasValue-001.ttl"
    "core/property/in-001.ttl"
    "core/property/languageIn-001.ttl" # one more result than expected
    "core/property/lessThan-001.ttl"
    "core/property/lessThan-002.ttl" # missing (duplicate?) results
    "core/property/lessThanOrEquals-001.ttl"
    "core/property/maxCount-001.ttl"
    "core/property/maxCount-002.ttl"
    "core/property/maxExclusive-001.ttl"
    "core/property/maxInclusive-001.ttl"
    "core/property/maxLength-001.ttl"
    "core/property/minCount-001.ttl"
    "core/property/minCount-002.ttl"
    "core/property/minExclusive-001.ttl"
    "core/property/minExclusive-002.ttl"
    "core/property/minLength-001.ttl"
    "core/property/node-001.ttl" # missing detail
    "core/property/node-002.ttl" # missing detail
    # "core/property/nodeKind-001.ttl" # check takes forever
    "core/property/not-001.ttl"
    "core/property/or-001.ttl"
    "core/property/or-datatypes-001.ttl" # parsing error
    "core/property/pattern-001.ttl"
    "core/property/pattern-002.ttl" # flag?
    "core/property/property-001.ttl" # conforms
    "core/property/qualifiedMinCountDisjoint-001.ttl" # todo
    "core/property/qualifiedValueShape-001.ttl" # todo
    "core/property/qualifiedValueShapesDisjoint-001.ttl" # todo
    "core/property/uniqueLang-001.ttl"
    "core/property/uniqueLang-002.ttl" # don't conform

    "core/targets/multipleTargets-001.ttl"
    "core/targets/targetClass-001.ttl"
    "core/targets/targetClassImplicit-001.ttl"
    "core/targets/targetNode-001.ttl"
    "core/targets/targetObjectsOf-001.ttl"
    "core/targets/targetSubjectsOf-001.ttl"
    "core/targets/targetSubjectsOf-002.ttl"

    "core/validation-reports/shared.ttl" # conforms
)

for file in "${files[@]}"
do
    echo -en "${file} "
    ./validate.sh $file
    if [[ $(cat ./test-result.ttl | wc -w) -eq 0 ]]; then
        echo -e "${RED}FAILED${NORMAL}"
        ((FAILED++))
    else
        echo -e "${GREEN}OK${NORMAL}"
        ((OK++))
    fi
done
echo ""

echo -e "${YELLOW}Tests:${NORMAL} ${GREEN}${OK} OK${NORMAL} ${RED}${FAILED} FAILED${NORMAL}"
if [[ ${FAILED} -eq 0 ]]; then
    exit 0
else
    exit 2
fi