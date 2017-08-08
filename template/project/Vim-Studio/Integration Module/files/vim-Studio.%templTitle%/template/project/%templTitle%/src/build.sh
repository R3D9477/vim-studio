#!/bin/bash

export OUTDIR_SRC="Export/neko/obj/"
export OUTDIR_DST="../"

rm ../*.n

################################################################################
echo "> building: VimStudioClient" #############################################
################################################################################

rm -rf ./Export
haxe build.hxml

cp $OUTDIR_SRC"init.n" $OUTDIR_DST
