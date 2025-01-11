rm -f dist/compile.n3
rm -f dist/validate.n3
cat rules/compile/*.n3 > dist/compile.n3
cat rules/validate/*.n3 > dist/validate.n3
# curl https://raw.githubusercontent.com/eyereasoner/lib-rdfs/main/lib-rdfs.n3 --output dist/lib-rdfs.n3
