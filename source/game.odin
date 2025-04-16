package game

import "core:c"
import sa "core:container/small_array"
import "core:fmt"
import rl "vendor:raylib"

_run: bool
_window_size: [2]i32 = {800, 600}
_back_color := rl.Color{22, 44, 53, 255}
_mode: GameMode = .TIMER
_debug_text: cstring = ""

init :: proc() {
	_run = true
	rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE, .WINDOW_MAXIMIZED})
	rl.SetTargetFPS(200)
	rl.InitWindow(_window_size.x, _window_size.y, "Blind Timer")
	// rl.SetExitKey(.KEY_NULL)
	rl.MaximizeWindow()

	GenerateTemplates()
	// for template in _gameTemplates {
	// 	fmt.println("Name:", template.name)
	// 	fmt.println("Description:", template.description)
	// 	fmt.println("Stack:", template.startingStack)
	// 	for i := 0; i < sa.len(template.levels); i += 1 {
	// 		fmt.println(sa.get(template.levels, i))
	// 	}
	// }
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
	rl.ClearBackground(_back_color)

	switch _mode {
	case .TIMER:
		TimerModeDraw(ft)
	case .SETTINGS:
		SettingsModeDraw(ft)
	}

	if len(_debug_text) > 0 {
		rl.DrawText(_debug_text, 0, _window_size.y - 20, 16, rl.GRAY)
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

