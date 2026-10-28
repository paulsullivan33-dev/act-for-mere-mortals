#!/bin/sh
# count.sh FILE -- print the number of lines and words in FILE.
set -eu
lines=$(wc -l < "$1")
words=$(wc -w < "$1")
echo "lines: $lines"
echo "words: $words"
