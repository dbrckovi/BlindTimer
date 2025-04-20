package game

import sa "core:container/small_array"
import "core:fmt"

_gameTemplates: [4]GameTemplate

GenerateTemplates :: proc() {
	_gameTemplates = {
		GenerateTemplate(
			"Very Fast",
			"Designed to end in 30–45 minutes",
			1000,
			{
				{10, 20, 300, 0},
				{15, 30, 300, 0},
				{25, 50, 300, 0},
				{50, 100, 300, 0},
				{75, 150, 300, 0},
				{100, 200, 300, 0},
				{150, 300, 300, 0},
				{200, 400, 300, 0},
				{300, 600, 300, 0},
			},
			{{.WHITE, 10, 14}, {.BLUE, 20, 8}, {.GREEN, 50, 10}, {.RED, 100, 2}},
		),
		GenerateTemplate(
			"Fast (Turbo)",
			"Great for finishing in 1–1.5 hours with 4–8 players",
			1500,
			{
				{10, 20, 600, 0},
				{20, 40, 600, 0},
				{30, 60, 600, 0},
				{50, 100, 600, 0},
				{100, 200, 600, 0},
				{200, 400, 600, 0},
				{300, 600, 600, 0},
				{500, 1000, 600, 0},
				{1000, 2000, 600, 0},
			},
			{{.WHITE, 10, 14}, {.BLUE, 20, 8}, {.GREEN, 50, 12}, {.RED, 100, 6}},
		),
		GenerateTemplate(
			"Casino Style (Slow)",
			"Designed for longer play, lasts 3+ hours, consistent with common chip values.",
			4040,
			{
				{20, 40, 900, 0},
				{40, 80, 900, 0},
				{50, 100, 900, 0},
				{100, 200, 900, 0},
				{150, 300, 900, 0},
				{200, 400, 900, 0},
				{300, 600, 900, 0},
				{400, 800, 900, 0},
				{600, 1200, 900, 0},
				{800, 1600, 900, 0},
				{1000, 2000, 900, 0},
			},
			{{.WHITE, 10, 8}, {.BLUE, 20, 8}, {.GREEN, 50, 20}, {.RED, 100, 28}},
		),
		GenerateTemplate(
			"Deep Stack Tournament",
			"Long-lasting, strategic, for large events, with deep starting stacks.",
			10000,
			{
				{20, 40, 1200, 0},
				{40, 80, 1200, 0},
				{50, 100, 1200, 0},
				{100, 200, 1200, 0},
				{150, 300, 1200, 0},
				{200, 400, 1200, 0},
				{300, 600, 1200, 0},
				{400, 800, 1200, 0},
				{600, 1200, 1200, 0},
				{800, 1600, 1200, 0},
				{1000, 2000, 1200, 0},
				{1500, 3000, 1200, 0},
			},
			{{.WHITE, 10, 10}, {.BLUE, 20, 10}, {.GREEN, 50, 40}, {.RED, 100, 77}},
		),
	}
}

GenerateTemplate :: proc(
	name: cstring,
	description: cstring,
	startingStack: i32,
	levels: []BlindLevel,
	chips: []ChipAmount,
) -> GameTemplate {

	ret: GameTemplate
	ret.name = name
	ret.description = description
	ret.startingStack = startingStack
	for level in levels {
		sa.append(&ret.levels, level)
	}
	for chipAmount in chips {
		sa.append(&ret.chips, chipAmount)
	}
	return ret
}

