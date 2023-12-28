#!/bin/bash -e

git clone https://github.com/typesafeschwalbe/gerastd gerastd
git clone https://github.com/typesafeschwalbe/geraccoredeps geraccoredeps

gerac \
    $(find gerastd/src -type f \( -iname \*.gera -o -iname \*.gem \)) \
    $(find src -type f \( -iname \*.gera -o -iname \*.gem \)) \
    -m gerap::main -t c -o gerap.c

cc \
    $(find gerastd/src-c -name "*.c") \
    gerap.c \
    geraccoredeps/coredeps.c \
    -I ./geraccoredeps/ \
    -lm -O3 -o gerap
