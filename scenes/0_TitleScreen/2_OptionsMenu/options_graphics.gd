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
	var is_accept_key = event is InputEventKey and event.keycode in [KEY_ENTER, KEY_Z] 
	if is_just_pressed and is_accept_key: callable.call()


func _get_menu() -> OptionsMenu:
	var menu = get_parent()
	return menu if menu is OptionsMenu else null

#===
func _connect_signals() -> void:
	size_container.gui_input.connect(_try_to_call.bind(_on_size_container_pressed))
	size_container.get_node("Value").gui_input.connect(_on_size_slider_gui_input)
	
	mode_container.gui_input.connect(_try_to_call.bind(_on_mode_container_pressed))
	mode_container.get_node("Value").gui_input.connect(_on_mode_slider_gui_input)
	
	shader_container.gui_input.connect(_try_to_call.bind(_on_shader_button_pressed))
	shader_container.get_node("Value").gui_input.connect(_on_shader_slider_gui_input)
	
	noise_container.gui_input.connect(_try_to_call.bind(_on_noise_button_pressed))
	noise_container.get_node("Value").gui_input.connect(_on_noise_slider_gui_input)
	
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


var size_states = {
	0: {
		"title": "640x360",
		"func": func(): Options.make_window_small()
	},
	1: {
		"title": "1280x720",
		"func": func(): Options.make_window_medium()
	},
	2: {
		"title": "1920x1080",
		"func": func(): Options.make_window_large()
	}
}

var current_size_state = 1

func _on_size_container_pressed():
	size_container.get_node("Value").grab_focus.call_deferred()
	size_container.get_node("Value").add_theme_color_override("font_color", Color.BLACK)
	AudioPlayer.play_sfx(Database.SE_MENU_HOVER)

func _on_size_slider_gui_input(event):
	var is_just_pressed = event.is_pressed() and not event.is_echo()
	if not (is_just_pressed and event is InputEventKey): return
	match event.keycode:
		KEY_Z:
			size_container.grab_focus.call_deferred()
			size_container.get_node("Value").remove_theme_color_override("font_color")
			AudioPlayer.play_sfx(Database.SE_MENU_OPEN)
			size_states[current_size_state]["func"].call()
		KEY_LEFT:
			if current_size_state > 0:
				current_size_state -= 1
				AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
				size_container.get_node("Value").text = size_states[current_size_state]["title"]
		KEY_RIGHT:
			if current_size_state < size_states.size() - 1:
				current_size_state += 1
				AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
				size_container.get_node("Value").text = size_states[current_size_state]["title"]




var mode_states = {
	0: {
		"title": "Окно",
		"func": func(): Options.windowed_window()
	},
	1: {
		"title": "Полный экран",
		"func": func(): Options.fullscreen_window()
	}
}

var current_mode_state = 0


func _on_mode_container_pressed():
	mode_container.get_node("Value").grab_focus.call_deferred()
	mode_container.get_node("Value").add_theme_color_override("font_color", Color.BLACK)
	AudioPlayer.play_sfx(Database.SE_MENU_HOVER)

func _on_mode_slider_gui_input(event):
	var is_just_pressed = event.is_pressed() and not event.is_echo()
	if not (is_just_pressed and event is InputEventKey): return
	match event.keycode:
		KEY_Z:
			mode_container.grab_focus.call_deferred()
			mode_container.get_node("Value").remove_theme_color_override("font_color")
			AudioPlayer.play_sfx(Database.SE_MENU_OPEN)
			mode_states[current_mode_state]["func"].call()
		KEY_LEFT:
			if current_mode_state > 0:
				current_mode_state -= 1
				AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
				mode_container.get_node("Value").text = mode_states[current_mode_state]["title"]
		KEY_RIGHT:
			if current_mode_state < mode_states.size() - 1:
				current_mode_state += 1
				AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
				mode_container.get_node("Value").text = mode_states[current_mode_state]["title"]





func _on_shader_button_pressed():
	shader_container.get_node("Value").grab_focus.call_deferred()
	shader_container.get_node("Value").add_theme_color_override("font_color", Color.BLACK)
	AudioPlayer.play_sfx(Database.SE_MENU_HOVER)

var shader_states = {
	"on": {
		"title": "On",
		"func": func(): Effects.abberation_on()
	},
	"off": {
		"title": "Off",
		"func": func(): Effects.abberation_off()
	}
}

var current_shader_state = "on"

var noise_states = {
	"on": {
		"title": "On",
		"func": func(): Effects.noise_on()
	},
	"off": {
		"title": "Off",
		"func": func(): Effects.noise_off()
	}
}

var current_noise_state = "on"

func _on_shader_slider_gui_input(event):
	var is_just_pressed = event.is_pressed() and not event.is_echo()
	if not (is_just_pressed and event is InputEventKey): return
	match event.keycode:
		KEY_Z:
			shader_container.grab_focus.call_deferred()
			shader_container.get_node("Value").remove_theme_color_override("font_color")
			AudioPlayer.play_sfx(Database.SE_MENU_OPEN)
		KEY_LEFT:
			if current_shader_state != "off":
				shader_states["off"]["func"].call()
				shader_container.get_node("Value").text = shader_states["off"]["title"]
				current_shader_state = "off"
				AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
		KEY_RIGHT:
			if current_shader_state != "on":
				shader_states["on"]["func"].call()
				shader_container.get_node("Value").text = shader_states["on"]["title"]
				current_shader_state = "on"
				AudioPlayer.play_sfx(Database.SE_MENU_HOVER)

func _on_noise_button_pressed():
	noise_container.get_node("Value").grab_focus.call_deferred()
	noise_container.get_node("Value").add_theme_color_override("font_color", Color.BLACK)
	AudioPlayer.play_sfx(Database.SE_MENU_HOVER)

func _on_noise_slider_gui_input(event):
	var is_just_pressed = event.is_pressed() and not event.is_echo()
	if not (is_just_pressed and event is InputEventKey): return
	match event.keycode:
		KEY_Z:
			noise_container.grab_focus.call_deferred()
			noise_container.get_node("Value").remove_theme_color_override("font_color")
			AudioPlayer.play_sfx(Database.SE_MENU_OPEN)
		KEY_LEFT:
			if current_noise_state != "off":
				noise_states["off"]["func"].call()
				noise_container.get_node("Value").text = noise_states["off"]["title"]
				current_noise_state = "off"
				AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
		KEY_RIGHT:
			if current_noise_state != "on":
				noise_states["on"]["func"].call()
				noise_container.get_node("Value").text = noise_states["on"]["title"]
				current_noise_state = "on"
				AudioPlayer.play_sfx(Database.SE_MENU_HOVER)

func _on_return_button_pressed() -> void:
	var menu = _get_menu()
	if menu:
		menu.return_to_initial_state()
		AudioPlayer.play_sfx(Database.SE_MENU_BACK)

func center():
	var focused_object = get_viewport().gui_get_focus_owner()
	if not focused_object in get_children(): return
	var index = focused_object.get_index()
	var viewport_heigh = ProjectSettings.get_setting("display/window/size/viewport_height")
	#работает только если все элементы равны по размеру
	var pivot_offset = index*(focused_object.size.y + get_theme_constant("separation")) + focused_object.size.y/2
	position.y = viewport_heigh/2.0 - pivot_offset
