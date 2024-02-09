#!/bin/bash -e

git clone https://github.com/geralang/std gerastd
git clone https://github.com/geralang/ccoredeps geraccoredeps

gerac \
    $(find std/src -type f \( -iname \*.gera -o -iname \*.gem \)) \
    $(find src -type f \( -iname \*.gera -o -iname \*.gem \)) \
    -m gerap::main -t c -o gerap.c

cc \
    $(find std/src-c -name "*.c") \
    gerap.c \
    ccoredeps/coredeps.c \
    -I ./ccoredeps/ \
    -lm -O3 -o gerap
