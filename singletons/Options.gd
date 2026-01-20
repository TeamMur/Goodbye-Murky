extends Node

var custom_options_file_name = "custom_options"

func _input(event: InputEvent) -> void:
	_bind_window_size(event)

func _ready() -> void:
	set_music_volume_linear(0.5)
	set_sound_volume_linear(0.5)
	load_options()
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		await save_options()
		get_tree().quit()

func load_options(options_dict = {}):
	if not options_dict: options_dict = Savebase.load_dict(custom_options_file_name)
	set_locale(options_dict["locale"])
	
	var s = Vector2i(int(options_dict["window_size_x"]), int(options_dict["window_size_y"]))
	set_window_size(s)
	set_window_mode(int(options_dict["window_mode"]))
	set_shader(options_dict["shader"])
	set_noise(options_dict["noise"])
	
	set_master_volume_linear(options_dict["master_volume"])
	set_music_volume_linear(options_dict["music_volume"])
	set_sound_volume_linear(options_dict["se_volume"])
	set_ambient_volume_linear(options_dict["ambient_volume"])
	
	#TODO: keys
	



#TODO
func save_options():
	var options_dict = default_options.duplicate()
	options_dict["locale"]         = get_locale()

	var s = get_window_size()
	options_dict["window_size_x"]  = s.x
	options_dict["window_size_y"]  = s.y
	options_dict["window_mode"]    = get_window_mode()
	options_dict["shader"]         = get_shader()
	options_dict["noise"]          = get_noise()

	options_dict["master_volume"]  = get_bus_volume_linear(master_bus)
	options_dict["music_volume"]   = get_bus_volume_linear(music_bus)
	options_dict["se_volume"]      = get_bus_volume_linear(sfx_bus)
	options_dict["ambient_volume"] = get_bus_volume_linear(ambient_bus)

	options_dict["up_key"]         = get_action_key("up")
	options_dict["down_key"]       = get_action_key("down")
	options_dict["left_key"]       = get_action_key("left")
	options_dict["right_key"]      = get_action_key("right")
	options_dict["accept_key"]     = get_action_key("z")
	options_dict["cancel_key"]     = get_action_key("x")
	options_dict["guide_key"]      = get_action_key("tab")
	options_dict["pause_key"]      = get_action_key("esc")
	
	Savebase.save_dict(options_dict, custom_options_file_name)


#region locale (язык)
func get_system_locale(): return OS.get_locale_language()

func get_locale():        return TranslationServer.get_locale()
func set_locale(locale):         TranslationServer.set_locale(locale)

#endregion
#region window mode (режим отображения)
func get_window_mode(): return DisplayServer.window_get_mode()
func set_window_mode(mode):    DisplayServer.window_set_mode(mode)

func hide_window():       set_window_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
func expand_window():     set_window_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
func windowed_window():   set_window_mode(DisplayServer.WINDOW_MODE_WINDOWED)
func fullscreen_window(): set_window_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

#endregion
#region window size (размер окна)
var small_window_size  = Vector2i(640, 360)
var medium_window_size = Vector2i(1280, 720)
var large_window_size  = Vector2i(1600, 900)

func get_window_size(): return DisplayServer.window_get_size()
func set_window_size(size):
	DisplayServer.window_set_size(size)
	center_window()

func make_window_small(): set_window_size(small_window_size)
func make_window_medium(): set_window_size(medium_window_size)
func make_window_large():
	#get_window().borderless = true
	#godot автоматически преобразует в fullscreen_exclusive
	set_window_size(large_window_size)

func center_window(): get_window().move_to_center()

#endregion

#region shaders

func get_shader(): return Effects.abberation.visible
func get_noise():  return Effects.noise.visible

func set_shader(flag):
	if flag: Effects.abberation_on()
	else:    Effects.abberation_off()
func set_noise(flag):
	if flag: Effects.noise_on()
	else:    Effects.noise_off()

#endregion

#region audio (звук)

var master_bus  = "Master"
var sfx_bus     = "SFX"
var music_bus   = "Music"
var ambient_bus = "Ambient"

func _get_bus_index(bus_name): return AudioServer.get_bus_index(bus_name)

func get_bus_volume_linear(bus_name): return AudioServer.get_bus_volume_linear(_get_bus_index(bus_name))
func set_bus_volume_linear(bus_name, value): AudioServer.set_bus_volume_linear(_get_bus_index(bus_name), value)

func mute_on(bus_name):  AudioPlayer.set_mute(bus_name, true)
func mute_off(bus_name): AudioPlayer.set_mute(bus_name, false)

func set_master_volume_linear(value):  set_bus_volume_linear(master_bus, value)
func set_music_volume_linear(value):   set_bus_volume_linear(music_bus, value)
func set_sound_volume_linear(value):   set_bus_volume_linear(sfx_bus, value)
func set_ambient_volume_linear(value): set_bus_volume_linear(ambient_bus, value)

#endregion

#region controls
func _get_local_actions():
	var actions = InputMap.get_actions()
	var action_count = actions.size()
	const default_action_count = 85
	return actions.slice(default_action_count, action_count)

func get_action_key(action):
	var keycode: int = InputMap.action_get_events(action)[0].physical_keycode
	return keycode
	

#endregion

#region binds
func _bind_lang(event):
	if event.is_pressed() and not event.is_echo():
		if event is InputEventKey and event.keycode == KEY_F1:
			print("язык изменен на русский")
			set_locale("ru")
		if event is InputEventKey and event.keycode == KEY_F2:
			print("язык изменен на английский")
			set_locale("en")
		if event is InputEventKey and event.keycode == KEY_F3:
			print("язык изменен на китайский")
			set_locale("ch")


func _bind_window_mode(event):
	if event.is_pressed() and not event.is_echo():
		if event is InputEventKey:
			match event.keycode:
				KEY_F6:
					var mode = get_window_mode()
					print("текущий режим отображения: ", _get_mode_string(mode))
				KEY_F1: set_window_mode(0)
				KEY_F2: set_window_mode(1)
				KEY_F3: set_window_mode(2)
				KEY_F4: set_window_mode(3)
				KEY_F5: set_window_mode(4)

func _get_mode_string(mode):
	var string
	match mode:
		0: string = "windowed"
		1: string = "minimized"
		2: string = "maximized"
		3: string = "fullscreen"
		4: string = "exclusive_fullscreen"
	return string

func _bind_window_size(event):
	if event.is_pressed() and not event.is_echo():
		if event is InputEventKey:
			match event.keycode:
				KEY_F6: print("текущий режим отображения: ", get_window_size())
				KEY_F1: make_window_small()
				KEY_F2: make_window_medium()
				KEY_F3: make_window_large()
				KEY_F4: windowed_window()
				KEY_F5: fullscreen_window()
#endregion


#===
var default_options: Dictionary = {
	"locale": 0,
	
	"window_size": 0,
	"window_mode": 0,
	"shader": 0,
	"noise": 0,
	
	"master_volume": 0,
	"music_volume": 0,
	"se_volume": 0,
	"ambient_volume": 0,
	
	"up_key": 0,
	"down_key": 0,
	"left_key": 0,
	"right_key": 0,
	"accept_key": 0,
	"cancel_key": 0,
	"guide_key": 0,
	"pause_key": 0,
}
