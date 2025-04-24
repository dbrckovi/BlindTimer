#!/bin/bash -eu

OUT_DIR="build/desktop"
./build_desktop.sh
./$OUT_DIR/game_desktop.bin
