package game

import sa "core:container/small_array"

GameMode :: enum {
	TIMER,
	SETTINGS,
}

BlindLevel :: struct {
	smallBlind:      i32,
	bigBlind:        i32,
	durationSeconds: i32,
	ante:            i32,
}

GameTemplate :: struct {
	name:          cstring,
	description:   cstring,
	startingStack: i32,
	levels:        sa.Small_Array(50, BlindLevel),
}

