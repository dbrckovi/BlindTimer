package game

import "core:c"
import sa "core:container/small_array"
import "core:fmt"
import "core:strings"
import "core:time"
import rl "vendor:raylib"

TOP_TEMPLATE_Y :: 40
_settings_back_color := rl.Color{33, 33, 33, 255}
_settingsTemplate: ^GameTemplate

SettingsModeUpdate :: proc() {

}

SettingsModeDraw :: proc(ft: f32) {
	rl.ClearBackground(_settings_back_color)
	center := GetWindowCenter()

	//templates
	rl.DrawText("Select template", 30, 10, 20, rl.ORANGE)

	for &template, i in _gameTemplates {
		original_checked := _settingsTemplate^ == template
		checked: bool = original_checked
		y: c.int = TOP_TEMPLATE_Y + c.int(i) * 25
		rl.GuiCheckBox({30, f32(y), 20, 20}, template.name, &checked)

		if original_checked != checked {
			_settingsTemplate = &template
		}
	}

	//template details
	details_y := TOP_TEMPLATE_Y + c.int(len(_gameTemplates)) * 25 + 15
	details_y2 := details_y + 25
	rl.DrawText("Selected template details", 30, details_y, 20, rl.ORANGE)

	builder := strings.builder_make()
	defer strings.builder_destroy(&builder)

	fmt.sbprintln(&builder, "Name:", _settingsTemplate.name)
	fmt.sbprintln(&builder, "Description:", _settingsTemplate.description)
	fmt.sbprintln(&builder, "Starting stack:", _settingsTemplate.startingStack)
	fmt.sbprintln(&builder, "Levels: (SB/BB - ANTE)")
	fmt.sbprintln(&builder, "")

	for i := 0; i < sa.len(_settingsTemplate.levels); i += 1 {
		level := sa.get(_settingsTemplate.levels, i)
		fmt.sbprintln(
			&builder,
			" ",
			level.smallBlind,
			"/",
			level.bigBlind,
			" - ",
			level.ante,
			" ,",
			level.durationSeconds,
			"sec",
		)
	}

	rl.DrawText(strings.to_cstring(&builder), 30, details_y2, 20, rl.WHITE)

	// buttons
	if rl.GuiButton({f32(center.x - 100), f32(_window_size.y - 40), 90, 30}, "OK") {
		_mode = .TIMER
		_currentTemplate = _settingsTemplate
		_currentBlindLevelIndex = 0
		_running = false
		_levelStartTime = time.now()
		_pauseAccumulated = 0
		_durationSinceLevelStart = 0
		_lastPauseStartTime = time.now()
	}

	if rl.GuiButton({f32(center.x + 10), f32(_window_size.y - 40), 90, 30}, "Cancel") {
		_mode = .TIMER
	}
}

