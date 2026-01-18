extends BoxContainer

@onready var mode_container: BoxContainer = $ModeContainer
@onready var size_container: BoxContainer = $SizeContainer
@onready var shader_container: BoxContainer = $ShaderContainer
@onready var noise_container: BoxContainer = $NoiseContainer

@onready var return_button: BoxContainer = $ReturnContainer


#===
func _ready() -> void:
	_connect_signals()

func _choised() -> void:
	_button_focus_grab()
	AudioPlayer.play_sfx(Database.SE_MENU_OPEN)


#===
func _try_to_call(event, callable) -> void:
	var is_just_pressed = event.is_pressed() and not event.is_echo()
	var is_accept_key = event.is_action("z")
	if is_just_pressed and is_accept_key: callable.call()


#===
func _connect_signals() -> void:
	for container in get_children():
		if container is BoxContainer and container != return_button:
			container.gui_input.connect(_try_to_call.bind(_on_container_pressed.bind(container)))
	
	size_container.get_node("Value").gui_input.connect(_on_window_slider_gui_input.bind(size_container))
	mode_container.get_node("Value").gui_input.connect(_on_window_slider_gui_input.bind(mode_container))
	
	shader_container.get_node("Value").gui_input.connect(_on_effect_slider_gui_input.bind(shader_container))
	noise_container.get_node("Value").gui_input.connect(_on_effect_slider_gui_input.bind(noise_container))
	
	return_button.gui_input.connect(_try_to_call.bind(_on_return_button_pressed))
	
	for button: BoxContainer in get_children():
		button.focus_entered.connect(_on_button_focus_entered.bind(button))
		button.focus_exited.connect(_on_button_focus_exited.bind(button))

func _button_focus_grab(index = 0) -> void:
	get_child(index).grab_focus.call_deferred()

func _on_button_focus_entered(box: BoxContainer) -> void:
	box.get_node("Title").add_theme_color_override("font_color", Color.BLACK)
	AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
	#center()

func _on_button_focus_exited(box: BoxContainer) -> void:
	box.get_node("Title").remove_theme_color_override("font_color")

func _on_container_pressed(container):
	container.get_node("Value").grab_focus.call_deferred()
	container.get_node("Value").add_theme_color_override("font_color", Color.BLACK)
	AudioPlayer.play_sfx(Database.SE_MENU_HOVER)

#region window sliders
func _on_window_slider_gui_input(event: InputEvent, container):
	var is_just_pressed = event.is_pressed() and not event.is_echo()
	if not (is_just_pressed and event is InputEventKey): return
	
	var value_label: Label = container.get_node("Value")
	var states = containers_states.get(container)
	
	match event.keycode:
		KEY_Z:     window_accept_option(container, value_label, states)
		KEY_LEFT:  window_left_option(value_label, states)
		KEY_RIGHT: window_right_option(value_label, states)

func window_accept_option(container, value_label, states):
	container.grab_focus.call_deferred()
	value_label.remove_theme_color_override("font_color")
	AudioPlayer.play_sfx(Database.SE_MENU_OPEN)
	
	states[states["current_state"]]["func"].call()

func window_left_option(value_label, states):
	if states["current_state"] > 0:
		states["current_state"] -= 1
		AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
		value_label.text = states[states["current_state"]]["title"]

func window_right_option(value_label, states):
	if states["current_state"] < states.size() - 2:
		states["current_state"] += 1
		AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
		value_label.text = states[states["current_state"]]["title"]

#endregion
#region effect sliders
func _on_effect_slider_gui_input(event: InputEvent, container):
	var is_just_pressed = event.is_pressed() and not event.is_echo()
	if not (is_just_pressed and event is InputEventKey): return
	
	var value_label: Label = container.get_node("Value")
	var states = containers_states.get(container)
	
	match event.keycode:
		KEY_Z:     effect_accept_option(container, value_label)
		KEY_LEFT:  effect_change_option(value_label, states, "off")
		KEY_RIGHT: effect_change_option(value_label, states, "on")

func effect_accept_option(container, value_label):
	container.grab_focus.call_deferred()
	value_label.remove_theme_color_override("font_color")

func effect_change_option(value_label, states, value):
	if states["current_state"] != value:
		states[value]["func"].call()
		value_label.text = states[value]["title"]
		states["current_state"] = value
		AudioPlayer.play_sfx(Database.SE_MENU_HOVER)

#endregion

func _on_return_button_pressed() -> void:
	var menu = _get_menu()
	if menu:
		menu.return_to_initial_state()
		AudioPlayer.play_sfx(Database.SE_MENU_BACK)

#===
func center():
	var focused_object = get_viewport().gui_get_focus_owner()
	if not focused_object in get_children(): return
	var index = focused_object.get_index()
	var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")/2
	#работает только если все элементы равны по размеру
	var p_offset = focused_object.size.y/2
	if index: p_offset += index*(focused_object.size.y + get_theme_constant("separation"))
	position.y = viewport_height - p_offset


#getters
func _get_menu() -> OptionsMenu:
	var menu = get_parent()
	return menu if menu is OptionsMenu else null

#region states
@onready var containers_states = {
	size_container:   size_states,
	mode_container:   mode_states,
	shader_container: shader_states,
	noise_container:  noise_states
}

var size_states = {
	"current_state": 1,
	0: {"title": "640x360",   "func": func(): Options.make_window_small()},
	1: {"title": "1280x720",  "func": func(): Options.make_window_medium()},
	2: {"title": "1920x1080", "func": func(): Options.make_window_large()}
}

var mode_states = {
	"current_state": 0,
	0: {"title": "Окно",         "func": func(): Options.windowed_window()},
	1: {"title": "Полный экран", "func": func(): Options.fullscreen_window()}
}

var shader_states = {
	"current_state": "",
	"on":  {"title": "On",   "func": func(): Effects.abberation_on()},
	"off": {"title": "Off", "func": func(): Effects.abberation_off()}
}

var noise_states = {
	"current_state": "",
	"on":  {"title": "On",   "func": func(): Effects.noise_on()},
	"off": {"title": "Off", "func": func(): Effects.noise_off()
	}
}
#endregion
