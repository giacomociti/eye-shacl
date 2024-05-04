rm -f dist/*.n3
eye --nope --quiet --pass-merged rules/compile/*.n3 --output dist/compile.n3
eye --nope --quiet --pass-merged rules/validate/*.n3 --output dist/validate.n3
cp rules/imports.n3 dist/imports.n3
cp rules/shapesGraph.n3 dist/shapesGraph.n3