package game

import "core:c"
import rl "vendor:raylib"

GetWindowCenter :: proc() -> [2]i32 {
	return _window_size / 2
}

//Draws text centered around a point
DrawTextCenter :: proc(text: cstring, cX, cY: c.int, fontSize: c.int, color: rl.Color) {
	textWidth := rl.MeasureText(text, fontSize)
	x := cX - textWidth / 2
	y := cY - fontSize / 2

	rl.DrawText(text, x, y, fontSize, rl.YELLOW)
}

//Scales the font relative to fullHD width (1920)
ScaleFont :: proc(fontSize: c.int) -> c.int {

	// fontSize / 1920 = result / _window_size.x
	return _window_size.x * fontSize / 1920
}

