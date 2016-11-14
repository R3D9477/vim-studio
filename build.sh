#!/bin/bash

ROOT=$PWD

cd "$PWD/sys/src"
./build.sh

cd "$PWD/template/project/Vim-Studio/Integration Module/files/vim-Studio.%templTitle%/template/project/%templTitle%/src"
./build.sh

cd "$PWD/template/project/Vim-Studio/Integration Module/files/vim-Studio.%templTitle%/template/file/%templTitle%/src"
./build.sh
