#!/bin/bash

ROOT=$PWD

cd "$ROOT/sys/src"
./build.sh

cd "$ROOT/template/project/Vim-Studio/Integration Module/files/vim-Studio.%templTitle%/template/project/%templTitle%/src"
./build.sh

cd "$ROOT/template/project/Vim-Studio/Integration Module/files/vim-Studio.%templTitle%/template/file/%templTitle%/src"
./build.sh
