rm -f dist/compile.n3
rm -f dist/validate.n3
eye --nope --quiet --pass-merged rules/compile/*.n3 --output dist/compile.n3
eye --nope --quiet --pass-merged rules/validate/*.n3 --output dist/validate.n3
curl https://raw.githubusercontent.com/eyereasoner/lib-rdfs/main/lib-rdfs.n3 --output dist/lib-rdfs.n3
