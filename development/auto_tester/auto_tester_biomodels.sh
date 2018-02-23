#!/bin/bash
set -e
set -x

docker build -t corc_auto_tester test_container 

docker run corc_auto_tester R -e 'source(system.file("tests", "other", "biomodels_test.R", package = "CoRC"))'
