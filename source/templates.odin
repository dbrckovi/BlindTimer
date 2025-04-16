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
		),
		GenerateTemplate(
			"Casino Style (Slow)",
			"For more serious play, lasts 3+ hours, 1,500–5,000 chip stacks.",
			5000,
			{
				{25, 50, 900, 0},
				{50, 100, 900, 0},
				{75, 150, 900, 0},
				{100, 200, 900, 0},
				{150, 300, 900, 0},
				{200, 400, 900, 0},
				{300, 600, 900, 25},
				{400, 800, 900, 50},
				{600, 1200, 900, 100},
				{800, 1600, 900, 200},
				{1000, 2000, 900, 300},
			},
		),
		GenerateTemplate(
			"Deep Stack Tournament ",
			"Long-lasting, strategic, used in larger events",
			10000,
			{
				{25, 50, 1200, 0},
				{50, 100, 1200, 0},
				{75, 150, 1200, 0},
				{100, 200, 1200, 0},
				{150, 300, 1200, 25},
				{200, 400, 1200, 25},
				{300, 600, 1200, 50},
				{400, 800, 1200, 75},
				{500, 1000, 1200, 100},
				{600, 1200, 1200, 100},
				{800, 1600, 1200, 200},
				{1000, 2000, 1200, 300},
			},
		),
	}
}

GenerateTemplate :: proc(
	name: cstring,
	description: cstring,
	startingStack: i32,
	levels: []BlindLevel,
) -> GameTemplate {
	ret: GameTemplate
	ret.name = name
	ret.description = description
	ret.startingStack = startingStack
	for level in levels {
		sa.append(&ret.levels, level)
	}
	return ret
}

