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


files=(
    "custom/test01.ttl"
    "custom/test02.ttl"
    "custom/test03.ttl"
    "custom/test04.ttl"
    "custom/test05.ttl"
    "custom/test06.ttl"
    "custom/test07.ttl"
    "custom/test08.ttl"
    "custom/test09.ttl"
    "custom/test10.ttl"
    "custom/test11.ttl"
    "custom/test12.ttl"
    "custom/test13.ttl"
    "custom/test14.ttl"
    "custom/test15.ttl"
    "custom/test16.ttl"
    "custom/test17.ttl"
    "custom/test18.ttl"
    "custom/test19.ttl"
    "custom/test20.ttl"
    "custom/test21.ttl"
    "custom/test22.ttl"
    "custom/test23.ttl"
    "custom/test24.ttl"
    "custom/test25.ttl"

    # https://github.com/w3c/data-shapes/tree/gh-pages/data-shapes-test-suite/tests/core

    "core/complex/personexample.ttl"
    "core/complex/shacl-shacl.ttl"

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
    # "core/node/datatype-001.ttl" # parsing error
    "core/node/datatype-002.ttl"
    "core/node/disjoint-001.ttl"
    "core/node/equals-001.ttl"
    "core/node/hasValue-001.ttl"
    "core/node/in-001.ttl"
    "core/node/languageIn-001.ttl"
    "core/node/maxExclusive-001.ttl"
    "core/node/maxInclusive-001.ttl"
    "core/node/maxLength-001.ttl"
    "core/node/minExclusive-001.ttl"
    "core/node/minInclusive-001.ttl"
    "core/node/minInclusive-002.ttl"
    # "core/node/minInclusive-003.ttl" # date offset
    "core/node/minLength-001.ttl"
    "core/node/node-001.ttl" 
    "core/node/nodeKind-001.ttl"
    "core/node/not-001.ttl"
    "core/node/not-002.ttl"
    "core/node/or-001.ttl"
    "core/node/pattern-001.ttl"
    # "core/node/pattern-002.ttl" # sh:flags ignored
    "core/node/qualified-001.ttl"
    "core/node/xone-001.ttl"
    "core/node/xone-duplicate.ttl"

    "core/path/path-alternative-001.ttl"
    "core/path/path-complex-001.ttl"
    "core/path/path-complex-002.ttl"
    "core/path/path-inverse-001.ttl"
    "core/path/path-oneOrMore-001.ttl"
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
    # "core/property/datatype-ill-formed.ttl" # parsing issue
    "core/property/disjoint-001.ttl"
    "core/property/equals-001.ttl"
    "core/property/hasValue-001.ttl"
    "core/property/in-001.ttl"
    "core/property/languageIn-001.ttl"
    "core/property/lessThan-001.ttl" 
    # "core/property/lessThan-002.ttl" # expected duplicates
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
    "core/property/node-001.ttl" 
    "core/property/node-002.ttl"
    # "core/property/nodeKind-001.ttl" # check takes forever
    "core/property/not-001.ttl"
    "core/property/or-001.ttl"
    # "core/property/or-datatypes-001.ttl" # parsing error
    "core/property/pattern-001.ttl"
    # "core/property/pattern-002.ttl" # sh:flags ignored
    # "core/property/property-001.ttl" # expected duplicate
    "core/property/qualifiedMinCountDisjoint-001.ttl"
    "core/property/qualifiedValueShape-001.ttl"
    "core/property/qualifiedValueShapesDisjoint-001.ttl"
    "core/property/uniqueLang-001.ttl"
    "core/property/uniqueLang-002.ttl"

    "core/targets/multipleTargets-001.ttl"
    "core/targets/targetClass-001.ttl"
    "core/targets/targetClassImplicit-001.ttl"
    "core/targets/targetNode-001.ttl"
    "core/targets/targetObjectsOf-001.ttl"
    "core/targets/targetSubjectsOf-001.ttl"
    "core/targets/targetSubjectsOf-002.ttl"

    # "core/validation-reports/shared.ttl" # expected duplicate
)

for file in "${files[@]}"
do
    if [[ $(./testFile.sh "${file}") -gt 0 ]]; then
        echo -e "${GREEN}OK${NORMAL} ${file}"
        ((OK++))
    else
        echo -e "${RED}FAILED${NORMAL} ${file}"
        ((FAILED++))
    fi
done

echo -e "${YELLOW}Tests:${NORMAL} ${GREEN}${OK} OK${NORMAL} ${RED}${FAILED} FAILED${NORMAL}"

if [[ ${FAILED} -eq 0 ]]; then
    exit 0
else
    exit 2
fi