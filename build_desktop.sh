#!/bin/bash -eu

OUT_DIR="build/desktop"
mkdir -p $OUT_DIR
odin build source/main_desktop -out:$OUT_DIR/game_desktop.bin -debug
mkdir -p ./$OUT_DIR/assets/
cp -R ./assets/*.* ./$OUT_DIR/assets/

