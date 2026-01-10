extends BoxContainer

@onready var sound_button: BoxContainer = $SoundContainer
@onready var music_button: BoxContainer = $MusicContainer
@onready var se_slider: AudioSlider = $SoundContainer/HSlider

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
	se_slider.value_changed.connect(func(val): AudioPlayer.play_sfx(Database.SE_MENU_HOVER))
	
	
	sound_button.gui_input.connect(_try_to_call.bind(_on_sound_button_pressed))
	music_button.gui_input.connect(_try_to_call.bind(_on_music_button_pressed))
	
	sound_button.get_node("HSlider").gui_input.connect(_try_to_call.bind(_on_sound_slider_pressed))
	music_button.get_node("HSlider").gui_input.connect(_try_to_call.bind(_on_music_slider_pressed))
	
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

func _on_sound_button_pressed():
	sound_button.get_node("HSlider").grab_focus.call_deferred()
	sound_button.get_node("Title").add_theme_color_override.bind("font_color", Color.BLACK).call_deferred()

func _on_music_button_pressed():
	music_button.get_node("HSlider").grab_focus.call_deferred()
	music_button.get_node("Title").add_theme_color_override.bind("font_color", Color.BLACK).call_deferred()

func _on_sound_slider_pressed():
	sound_button.grab_focus.call_deferred()

func _on_music_slider_pressed():
	music_button.grab_focus.call_deferred()

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
