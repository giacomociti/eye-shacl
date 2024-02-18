for file in test/test*.n3; do
    echo "=============  Running test: $file"
    eye --nope --quiet --query test/pass.n3 rules/*.n3 "$file"
    echo
done
