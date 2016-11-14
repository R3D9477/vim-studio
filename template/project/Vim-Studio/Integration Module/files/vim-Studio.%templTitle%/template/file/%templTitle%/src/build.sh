#!/bin/bash

rm -rf ./Export
haxe build.hxml

rm ../init.n
cp ./Export/%os%%cpuArch%/neko/bin/init.n ../
