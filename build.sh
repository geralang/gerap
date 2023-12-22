#!/bin/bash -e

git clone https://github.com/typesafeschwalbe/gerastd gerastd
git clone https://github.com/typesafeschwalbe/gerastd-c gerastd-c

gerac \
    $(find gerastd/src -type f \( -iname \*.gera -o -iname \*.gem \)) \
    $(find gerastd-c/src -type f \( -iname \*.gera -o -iname \*.gem \)) \
    $(find src -type f \( -iname \*.gera -o -iname \*.gem \)) \
    -m gerap::main -t c -o gerap.c

cc \
    $(find gerastd-c/src-c -name "*.c") \
    gerap.c \
    -lm -O3 -o gerap
