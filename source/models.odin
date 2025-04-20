package game

import sa "core:container/small_array"

GameMode :: enum {
	TIMER,
	SETTINGS,
}

ChipColor :: enum {
	WHITE,
	GREEN,
	BLUE,
	RED,
	BLACK,
	YELLOW,
}

ChipAmount :: struct {
	color:  ChipColor,
	amount: i32,
	tokens: i32,
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
	chips:         map[ChipColor]i32,
}

