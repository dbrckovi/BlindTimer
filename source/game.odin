package game

import "core:c"
import rl "vendor:raylib"

_run: bool
_sound_level_change: rl.Sound
_window_size: [2]i32 = {800, 600}
_mode: GameMode = .TIMER
_debug_text: cstring = ""
_must_click: bool = false

init :: proc() {
	_run = true

	if ODIN_OS == .JS {_must_click = true}

	rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE, .WINDOW_MAXIMIZED})
	rl.SetTargetFPS(200)
	rl.InitWindow(_window_size.x, _window_size.y, "Blind Timer")
	rl.GuiSetStyle(rl.GuiControl.DEFAULT, i32(rl.GuiDefaultProperty.TEXT_SIZE), 20)
	// rl.SetExitKey(.KEY_NULL)
	rl.MaximizeWindow()

	rl.InitAudioDevice()
	rl.SetMasterVolume(1)

	_sound_level_change = rl.LoadSound("assets/chirp.wav")

	rl.SetSoundVolume(_sound_level_change, 1)

	GenerateTemplates()

	_currentTemplate = &_gameTemplates[0]
}

update :: proc() {
	ft := rl.GetFrameTime()
	_window_size.x = rl.GetRenderWidth()
	_window_size.y = rl.GetRenderHeight()

	switch _mode {
	case .TIMER:
		TimerModeUpdate()
	case .SETTINGS:
		SettingsModeUpdate()
	}

	draw(ft)
	free_all(context.temp_allocator)
}

draw :: proc(ft: f32) {
	rl.BeginDrawing()

	switch _mode {
	case .TIMER:
		TimerModeDraw(ft)
	case .SETTINGS:
		SettingsModeDraw(ft)
	}

	if len(_debug_text) > 0 {
		DrawTextCenter(_debug_text, _window_size.x / 2, _window_size.y - 30, 20, rl.YELLOW)
	}

	if _must_click {
		if rl.GuiButton(
			{f32(_window_size.x / 2 - 200), f32(_window_size.y / 2 - 100), 400, 200},
			"Click here to enable sound in browser",
		) {
			_must_click = false
		}
	}

	rl.EndDrawing()
}

parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(c.int(w), c.int(h))
}

shutdown :: proc() {
	rl.CloseWindow()
}

should_run :: proc() -> bool {
	when ODIN_OS != .JS {
		if rl.WindowShouldClose() {
			_run = false
		}
	}

	return _run
}

