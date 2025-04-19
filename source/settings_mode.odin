package game

import rl "vendor:raylib"

_settings_back_color := rl.Color{33, 33, 33, 255}

SettingsModeUpdate :: proc() {

}

SettingsModeDraw :: proc(ft: f32) {
	rl.ClearBackground(_settings_back_color)
	center := GetWindowCenter()

	if rl.GuiButton({f32(center.x - 100), f32(_window_size.y - 40), 90, 30}, "OK") {
		_mode = .TIMER
	}

	if rl.GuiButton({f32(center.x + 10), f32(_window_size.y - 40), 90, 30}, "Cancel") {
		_mode = .TIMER
	}
}

