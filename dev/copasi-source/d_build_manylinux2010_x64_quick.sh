#!/bin/bash
set -e
set -x

chmod +x ./build_linux_x64_quick.sh

docker build --pull -t corc_compiler_manylinux2010_x64 compilers/manylinux2010_x64

user=$UID:$(id -g $USER)
docker run --rm -v $PWD:/work -u $user corc_compiler_manylinux2010_x64 ./build_linux_x64_quick.sh
