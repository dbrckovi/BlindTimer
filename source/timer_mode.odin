package game

import "core:fmt"
import rl "vendor:raylib"

TimerModeUpdate :: proc() {

}

TimerModeDraw :: proc(ft: f32) {
	center := GetWindowCenter()
	text := fmt.ctprint("12:12")
	DrawTextCenter(text, center.x, center.y, ScaleFont(440), rl.YELLOW)
}

