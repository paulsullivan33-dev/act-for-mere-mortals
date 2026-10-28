#!/bin/sh
# test.sh -- check count.sh against the known sample file.
set -eu
out=$(./count.sh sample.txt)
echo "$out"
echo "$out" | grep -q "lines: 2"
echo "$out" | grep -q "words: 9"
echo "test.sh: all checks passed"
