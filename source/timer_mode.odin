package game

import "core:fmt"
import "core:time"
import rl "vendor:raylib"

_running := false //if game is not running, it's paused
_levelStartTime := time.now() //when current BlindLevel timer started
_lastPauseStartTime := time.now() //last time game was paused
_durationSinceStart: time.Duration //duration since level started (minus pauses)
_pauseAccumulated: time.Duration //total duration of all pauses since level started
_pauseBlinkStart: time.Time //Time when blink color switched in pause mode
_pauseBlinkState := false //Current blink state in pause mode

_timer_back_color := rl.Color{22, 44, 53, 255}
_timer_back_color_paused := rl.Color{22, 5, 5, 255}
_time_color := rl.Color{220, 220, 255, 255}
_time_color_paused := rl.ORANGE
_blind_color := rl.Color{220, 220, 255, 255}

TimerModeUpdate :: proc() {
	if _running { 	// normal running mode

		_durationSinceStart = time.since(
			time.time_add(_levelStartTime, time.Nanosecond * _pauseAccumulated),
		)

		if rl.IsKeyPressed(.SPACE) {
			//going into pause
			_lastPauseStartTime = time.now()
			_running = false
			_pauseBlinkState = true
			_pauseBlinkStart = time.now()
		}
	} else { 	// pause mode

		// switch blink color if eniugh time passed
		pauseBlinkDuration := time.since(_pauseBlinkStart)
		if time.duration_milliseconds(pauseBlinkDuration) > 300 {
			_pauseBlinkState = !_pauseBlinkState
			_pauseBlinkStart = time.now()
		}

		if rl.IsKeyPressed(.SPACE) {
			//resuming pause or starting
			_pauseAccumulated += time.since(_lastPauseStartTime)
			_running = true
		}
	}
}

TimerModeDraw :: proc(ft: f32) {
	rl.ClearBackground(_running ? _timer_back_color : _timer_back_color_paused)
	center := GetWindowCenter()

	if rl.GuiButton({f32(_window_size.x - 70), 10, 50, 30}, "* * *") {
		_mode = .SETTINGS
	}

	// Level name
	levelName: cstring = "Tournament (slow fast bla) - level 1"
	DrawTextCenter(levelName, center.x, center.y / 8, ScaleFont(80), rl.BLUE)

	//Main central timer
	timeText := VisualizeTime(_durationSinceStart)
	timeColor := _time_color
	if !_running && _pauseBlinkState {timeColor = _time_color_paused}
	DrawTextCenter(timeText, center.x, center.y - center.y / 4, ScaleFont(350), timeColor)

	//Blinds
	DrawTextCenter(
		"2000/4000   200",
		center.x,
		center.y + center.y / 3,
		ScaleFont(150),
		_blind_color,
	)

	DrawTextCenter(
		"3000/6000   300",
		center.x,
		_window_size.y - _window_size.y / 6,
		ScaleFont(100),
		rl.GRAY,
	)

	chipRadius := f32(ScaleFont(60))
	firstChipY := i32(f32(_window_size.y) * 0.2)
	chipX := i32(chipRadius) + 10
	DrawChip(
		rl.WHITE,
		rl.BLACK,
		{chipX, firstChipY + i32(chipRadius * 0) * 2},
		chipRadius,
		1000,
		1,
	)
	DrawChip(
		rl.BLUE,
		rl.WHITE,
		{chipX, firstChipY + i32(chipRadius * 1) * 2},
		chipRadius,
		3000,
		10,
	)
	DrawChip(
		rl.GREEN,
		rl.WHITE,
		{chipX, firstChipY + i32(chipRadius * 2) * 2},
		chipRadius,
		3000,
		100,
	)
	DrawChip(
		rl.RED,
		rl.WHITE,
		{chipX, firstChipY + i32(chipRadius * 3) * 2},
		chipRadius,
		3000,
		888,
	)
}

DrawChip :: proc(c1, c2: rl.Color, center: [2]i32, radius: f32, value: i32, tokens: i32) {
	segments := 18
	floatCenter := rl.Vector2{f32(center.x), f32(center.y)}
	rl.DrawCircleV(floatCenter, radius, c1)
	for angle := 0; angle < 360; angle += 360 / segments * 2 {
		rl.DrawCircleSector(
			floatCenter,
			radius,
			f32(angle),
			f32(angle) + 360 / f32(segments),
			5,
			c2,
		)
	}
	rl.DrawCircleV(floatCenter, radius * 0.8, c1)
	DrawTextCenter(fmt.ctprint(value), center.x, center.y, ScaleFont(36), c2)
	DrawTextCenter(
		fmt.ctprint("x", tokens),
		center.x + i32(radius) * 2,
		center.y,
		ScaleFont(36),
		rl.WHITE,
	)
}

