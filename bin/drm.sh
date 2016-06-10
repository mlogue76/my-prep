#!/bin/sh

tests="test_xa.exp tcc_mr_test.exp test_jextproc.exp sigtest.exp apm_test.exp"

for t in $tests
do
  find $TB_HOME -type f -path '*tests/Jamfile' | xargs grep "$t"
done
