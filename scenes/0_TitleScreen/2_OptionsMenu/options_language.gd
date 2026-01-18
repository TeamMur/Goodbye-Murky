extends BoxContainer

@onready var ru_button: Label = $RuButton
@onready var en_button: Label = $EnButton
@onready var ch_button: Label = $ChButton

@onready var return_button: Label = $ReturnButton

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
	ru_button.gui_input.connect(_try_to_call.bind(_on_ru_button_pressed))
	en_button.gui_input.connect(_try_to_call.bind(_on_en_button_pressed))
	ch_button.gui_input.connect(_try_to_call.bind(_on_ch_button_pressed))
	
	return_button.gui_input.connect(_try_to_call.bind(_on_return_button_pressed))
	
	for button: Label in get_children():
		button.focus_entered.connect(_on_button_focus_entered.bind(button))
		button.focus_exited.connect(_on_button_focus_exited.bind(button))

func _button_focus_grab(index = 0) -> void:
	get_child(index).grab_focus.call_deferred()

func _on_button_focus_entered(button: Label) -> void:
	button.add_theme_color_override("font_color", Color.BLACK)
	AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
	center()

func _on_button_focus_exited(button) -> void:
	button.remove_theme_color_override("font_color")

func _on_ru_button_pressed(): TranslationServer.set_locale("ru")
func _on_en_button_pressed(): TranslationServer.set_locale("en")
func _on_ch_button_pressed(): TranslationServer.set_locale("ch")

func _on_return_button_pressed() -> void:
	var menu = _get_menu()
	if menu:
		menu.return_to_initial_state()
		AudioPlayer.play_sfx(Database.SE_MENU_BACK)

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
