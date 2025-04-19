package game

import "core:fmt"
import "core:time"
import rl "vendor:raylib"

_running := false //if game is not running, it's paused
_levelStartTime := time.now() //when current BlindLevel timer started
_lastPauseStartTime := time.now() //last time game was paused
_durationSinceStart: time.Duration //duration since level started (minus pauses)
_pauseAccumulated: time.Duration //total duration of all pauses since level started
_timer_back_color := rl.Color{22, 44, 53, 255}

TimerModeUpdate :: proc() {
	if _running {
		_durationSinceStart = time.since(
			time.time_add(_levelStartTime, time.Nanosecond * _pauseAccumulated),
		)
		if rl.IsKeyPressed(.SPACE) {
			//going into pause
			_lastPauseStartTime = time.now()
			_running = false
		}
	} else {
		if rl.IsKeyPressed(.SPACE) {
			//resuming pause or starting
			_pauseAccumulated += time.since(_lastPauseStartTime)
			_running = true
		}
	}
}

TimerModeDraw :: proc(ft: f32) {
	rl.ClearBackground(_timer_back_color)
	center := GetWindowCenter()

	if _running {
		rl.DrawText("Running", 10, 10, ScaleFont(50), rl.WHITE)
	} else {
		rl.DrawText("Paused", 10, 10, ScaleFont(50), rl.YELLOW)
	}

	if rl.GuiButton({f32(_window_size.x - 70), 10, 50, 30}, "* * *") {
		_mode = .SETTINGS
	}

	text := VisualizeTime(_durationSinceStart)
	DrawTextCenter(text, center.x, center.y, ScaleFont(400), rl.YELLOW)
}

