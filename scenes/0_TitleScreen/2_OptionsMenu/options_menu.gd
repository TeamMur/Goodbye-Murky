class_name OptionsMenu extends Node
static var alias: String = "options_menu"

@onready var button_container:   BoxContainer = $ButtonContainer
@onready var lang_button:        Label = $ButtonContainer/LangButton
@onready var graphics_button:    Label = $ButtonContainer/GraphicsButton
@onready var sound_button:       Label = $ButtonContainer/SoundButton
@onready var controls_button:    Label = $ButtonContainer/ControlsButton
@onready var reset_button:       Label = $ButtonContainer/ResetButton
@onready var return_button:      Label = $ButtonContainer/ReturnButton

@onready var language_container: BoxContainer = $LanguageContainer
@onready var graphics_container: BoxContainer = $GraphicsContainer
@onready var audio_container:    BoxContainer = $AudioContainer
@onready var controls_container: BoxContainer = $ControlsContainer


#===
func _ready() -> void:
	_as_current()
	_connect_signals()

func _choised() -> void: _button_focus_grab()

#===
func _try_to_call(event: InputEvent, callable: Callable) -> void:
	var is_just_pressed = event.is_pressed() and not event.is_echo()
	var is_accept_key = event.is_action("z")
	if is_just_pressed and is_accept_key: callable.call()


#===
func _connect_signals() -> void:
	lang_button.gui_input.connect(_try_to_call.bind(_on_lang_button_pressed))
	graphics_button.gui_input.connect(_try_to_call.bind(_on_graphics_button_pressed))
	sound_button.gui_input.connect(_try_to_call.bind(_on_sound_button_pressed))
	controls_button.gui_input.connect(_try_to_call.bind(_on_controls_button_pressed))
	reset_button.gui_input.connect(_try_to_call.bind(_on_reset_button_pressed))
	return_button.gui_input.connect(_try_to_call.bind(_on_return_button_pressed))
	
	for button: Label in button_container.get_children():
		button.focus_entered.connect(_on_button_focus_entered.bind(button))
		button.focus_exited.connect(_on_button_focus_exited.bind(button))

func _button_focus_grab(index = 0) -> void:
	button_container.get_child(index).grab_focus.call_deferred()

func _on_button_focus_entered(button: Label) -> void:
	button.add_theme_color_override("font_color", Color.BLACK)
	AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
	center()

func _on_button_focus_exited(button) -> void:
	button.remove_theme_color_override("font_color")

func _on_category_pressed(category):
	_hide_containers()
	category.show()
	category._choised()

func _on_lang_button_pressed()     -> void: _on_category_pressed(language_container)
func _on_graphics_button_pressed() -> void: _on_category_pressed(graphics_container)
func _on_sound_button_pressed()    -> void: _on_category_pressed(audio_container)
func _on_controls_button_pressed() -> void: _on_category_pressed(controls_container)
func _on_reset_button_pressed()    -> void:
	Options.load_options(Savebase.load_dict("default_options"))


func _on_return_button_pressed() -> void:
	var title_screen = _get_title_screen()
	if title_screen:
		title_screen.change_screen_to_main_menu()
		AudioPlayer.play_sfx(Database.SE_MENU_BACK)
		Options.save_options()

#===
func _hide_containers(): for child in get_children(): if child is BoxContainer: child.hide()

func return_to_initial_state():
	_hide_containers()
	button_container.show()
	_button_focus_grab()

#===
func center():
	var focused_object = get_viewport().gui_get_focus_owner()
	if not focused_object in button_container.get_children(): return
	var index = focused_object.get_index()
	var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")/2
	#работает только если все элементы равны по размеру
	var pivot_offset = focused_object.size.y/2
	if index: pivot_offset += index*(focused_object.size.y + button_container.get_theme_constant("separation"))
	button_container.position.y = viewport_height - pivot_offset

#getters
func _get_title_screen() -> TitleScreen:
	var title_screen = get_parent()
	return title_screen if title_screen is TitleScreen else null

#===
func _as_current():
	if get_tree().current_scene == self:
		return_button.gui_input.connect(_try_to_call.bind(func(): get_tree().change_scene_to_file("res://scenes/0_TitleScreen/TitleScreen.tscn")))
		_choised()
