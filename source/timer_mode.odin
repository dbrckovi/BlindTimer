package game

import sa "core:container/small_array"
import "core:fmt"
import "core:time"
import rl "vendor:raylib"

_running := false //if game is not running, it's paused
_levelStartTime := time.now() //when current BlindLevel timer started
_lastPauseStartTime := time.now() //last time game was paused
_durationSinceLevelStart: time.Duration //duration since level started (minus pauses)
_pauseAccumulated: time.Duration //total duration of all pauses since level started
_pauseBlinkStart: time.Time //Time when blink color switched in pause mode
_pauseBlinkState := false //Current blink state in pause mode
_currentTemplate: ^GameTemplate
_currentBlindLevelIndex := 0 //Current blind level

_timer_back_color := rl.Color{22, 44, 53, 255}
_timer_back_color_paused := rl.Color{22, 5, 5, 255}
_time_color := rl.Color{220, 220, 255, 255}
_time_color_paused := rl.ORANGE
_blind_color := rl.Color{220, 220, 255, 255}

TimerModeUpdate :: proc() {
	if _running { 	// normal running mode

		_durationSinceLevelStart = time.since(
			time.time_add(_levelStartTime, time.Nanosecond * _pauseAccumulated),
		)

		timeLeft := GetTimeLeft()

		// if timeLeft <= 1 {
		// 	//TODO: Play warning sound
		// }

		if timeLeft <= 0 {
			if !IsLastBlindLevel() { 	//next level
				// TODO: Play switching sound
				_levelStartTime = time.now()
				_currentBlindLevelIndex += 1

			}
		}

		if rl.IsKeyPressed(.SPACE) {
			PauseGame()
		}
	} else { 	// pause mode

		// switch blink color if enough time passed
		pauseBlinkDuration := time.since(_pauseBlinkStart)
		if time.duration_milliseconds(pauseBlinkDuration) > 300 {
			_pauseBlinkState = !_pauseBlinkState
			_pauseBlinkStart = time.now()
		}

		if rl.IsKeyPressed(.SPACE) {
			ResumeGame()
		}
	}
}

TimerModeDraw :: proc(ft: f32) {
	rl.ClearBackground(_running ? _timer_back_color : _timer_back_color_paused)
	center := GetWindowCenter()

	if rl.GuiButton({f32(_window_size.x - 70), 10, 50, 30}, ". . .") {
		_mode = .SETTINGS
		if _running {PauseGame()}
	}

	// Level name
	levelNameColor := _running ? rl.BLUE : rl.RED
	levelNameText := _running ? _currentTemplate.name : "Paused"
	DrawTextCenter(levelNameText, center.x, center.y / 8, ScaleFont(80), levelNameColor)

	//Main central timer
	if IsLastBlindLevel() {
		DrawTextCenter("END", center.x, center.y - center.y / 4, ScaleFont(350), rl.YELLOW)

	} else {
		timeText := VisualizeTime(GetTimeLeft())
		timeColor := _time_color
		if !_running && _pauseBlinkState {timeColor = _time_color_paused}
		DrawTextCenter(timeText, center.x, center.y - center.y / 4, ScaleFont(350), timeColor)
	}
	//Big blind
	if sa.len(_currentTemplate.levels) <= _currentBlindLevelIndex {
		panic("Current blind level index is outside of the array")
	}
	level := sa.get(_currentTemplate.levels, _currentBlindLevelIndex)

	DrawTextCenter(
		fmt.ctprintf("%d/%d   %d", level.smallBlind, level.bigBlind, level.ante),
		center.x,
		center.y + center.y / 3,
		ScaleFont(150),
		_blind_color,
	)

	//Small blind
	if sa.len(_currentTemplate.levels) > _currentBlindLevelIndex + 1 {
		nextLevel := sa.get(_currentTemplate.levels, _currentBlindLevelIndex + 1)
		DrawTextCenter(
			fmt.ctprintf("%d/%d   %d", nextLevel.smallBlind, nextLevel.bigBlind, nextLevel.ante),
			center.x,
			_window_size.y - _window_size.y / 6,
			ScaleFont(100),
			rl.GRAY,
		)
	}

	//Chips
	chipRadius := f32(ScaleFont(60))
	firstChipY := i32(f32(_window_size.y) * 0.2)
	chipX := i32(chipRadius) + 10

	for i := 0; i < sa.len(_currentTemplate.chips); i += 1 {
		chip := sa.get(_currentTemplate.chips, i)
		c1, c2 := GetChipColors(chip.color)
		DrawChip(
			c1,
			c2,
			{chipX, firstChipY + i32(chipRadius * f32(i)) * 2},
			chipRadius,
			chip.amount,
			chip.tokens,
		)
	}
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

PauseGame :: proc() {
	if !_running {panic("Can't pause a paused game")}
	_lastPauseStartTime = time.now()
	_running = false
	_pauseBlinkState = true
	_pauseBlinkStart = time.now()
}

ResumeGame :: proc() {
	if _running {panic("Can't resume a game which is not paused")}
	_pauseAccumulated += time.since(_lastPauseStartTime)
	_running = true
}

GetTimeLeft :: proc() -> time.Duration {
	currentBlindLevel: BlindLevel = sa.get(_currentTemplate.levels, _currentBlindLevelIndex)
	timeLeft: time.Duration =
		time.Second * time.Duration(currentBlindLevel.durationSeconds) - _durationSinceLevelStart
	return timeLeft
}

IsLastBlindLevel :: proc() -> bool {
	return _currentBlindLevelIndex >= sa.len(_currentTemplate.levels) - 1
}

