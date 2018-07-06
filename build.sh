#!/bin/bash
#

mkdir -p build_so
(cd build_so && cmake .. && cmake --build .)

mkdir -p build_a
(cd build_a && cmake -DFREEIMAGE_BUILD_STATIC=1 .. && cmake --build .)
