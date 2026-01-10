class_name OptionsMaster extends Node

func _input(event: InputEvent) -> void:
	_bind_window_size(event)

#===locale
##не входит в настройки по умолчанию
func get_system_locale(): return OS.get_locale_language()

func get_locale():        return TranslationServer.get_locale()
func set_locale(locale):         TranslationServer.set_locale(locale)


#===window mode


func get_window_mode(): return DisplayServer.window_get_mode()
func set_window_mode(mode):    DisplayServer.window_set_mode(mode)

func hide_window():       set_window_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
func expand_window():     set_window_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
func windowed_window():   set_window_mode(DisplayServer.WINDOW_MODE_WINDOWED)
func fullscreen_window(): set_window_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


#===window size
var small_window_size = Vector2i(640, 360)
var medium_window_size = Vector2i(1280, 720)
var large_window_size = Vector2i(1920, 1080)

func get_window_size(): return DisplayServer.window_get_size()
func set_window_size(size):    DisplayServer.window_set_size(size)

func make_window_small():
	set_window_size(small_window_size)
	center_window()

func make_window_medium():
	set_window_size(medium_window_size)
	center_window()

func make_window_large():
	#get_window().borderless = true
	#godot автоматически преобразует в fullscreen_exclusive
	set_window_size(large_window_size)
	center_window()

func center_window(): get_window().move_to_center()

##func shader_on
##func noise_on


#===audio

var master_bus  = "Master"
var sfx_bus     = "SFX"
var music_bus   = "Music"
var ambient_bus = "Ambient"

func _get_bus_index(bus_name): return AudioServer.get_bus_index(bus_name)

func get_bus_volume(bus_name): return AudioServer.get_bus_volume_linear(bus_name)
func set_bus_volume(bus_name, value): AudioServer.set_bus_volume_linear(bus_name, value)

func mute_on(bus_name):  ST_AudioMaster.set_mute(bus_name, true)
func mute_off(bus_name): ST_AudioMaster.set_mute(bus_name, false)

#===
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
