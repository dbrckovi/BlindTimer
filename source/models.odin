package game

import sa "core:container/small_array"
import rl "vendor:raylib"

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
	chips:         sa.Small_Array(10, ChipAmount),
}

GetChipColors :: proc(chipColor: ChipColor) -> (rl.Color, rl.Color) {
	c1, c2: rl.Color

	switch (chipColor) {
	case .WHITE:
		c1 = rl.WHITE
		c2 = rl.BLACK
	case .GREEN:
		c1 = rl.GREEN
		c2 = rl.WHITE
	case .BLUE:
		c1 = rl.BLUE
		c2 = rl.WHITE
	case .RED:
		c1 = rl.RED
		c2 = rl.WHITE
	case .BLACK:
		c1 = rl.BLACK
		c2 = rl.WHITE
	case .YELLOW:
		c1 = rl.YELLOW
		c2 = rl.WHITE
	}

	return c1, c2
}

