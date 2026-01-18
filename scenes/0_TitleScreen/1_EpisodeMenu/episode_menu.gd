class_name EpisodeMenu extends Node
static var alias: String = "episode_menu"


@onready var button_container: BoxContainer = $ButtonContainer
@onready var return_button: Label = $ButtonContainer/ReturnButton
@onready var preview: TextureRect = $Preview
@onready var episode_title: Label = $EpisodeTitle


#===
func _ready() -> void:
	Savebase.last_unlocked_level = preview.images.size()
	if get_tree().current_scene == self: _choised()
	
	_connect_signals()

func _choised() -> void:
	_button_focus_grab(1)
	AudioPlayer.music.stop()


#===
func _try_to_call(event: InputEvent, callable: Callable) -> void:
	var is_just_pressed = event.is_pressed() and not event.is_echo()
	var is_accept_key = event.is_action("z")
	if is_just_pressed and is_accept_key: callable.call()


#===
func _connect_signals() -> void:
	return_button.gui_input.connect(_try_to_call.bind(_on_return_button_pressed))
	
	for button: Label in button_container.get_children():
		button.focus_entered.connect(_on_button_focus_entered.bind(button))
		button.focus_exited.connect(_on_button_focus_exited.bind(button))
		if button != return_button:
			button.gui_input.connect(_try_to_call.bind(_on_level_button_pressed.bind(button)))


func _button_focus_grab(index = 0) -> void:
	button_container.get_child(index).grab_focus.call_deferred()

func _on_button_focus_entered(button: Label) -> void:
	button.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	button.add_theme_color_override("font_color", Color.BLACK)
	AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
	center()
	
	var index = button.get_index()
	episode_title.update(index)
	preview.update(index)

func _on_button_focus_exited(button) -> void:
	button.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	button.remove_theme_color_override("font_color")

func _on_return_button_pressed() -> void:
	var title_screen = _get_title_screen()
	if title_screen: title_screen.change_screen_to_main_menu()
	AudioPlayer.play_sfx(Database.SE_MENU_BACK)

func _on_level_button_pressed(button) -> void:
	var index = button.get_index()
	var episode_path = Database.episode_pattern % index
	
	if FileAccess.file_exists(episode_path):
		get_tree().change_scene_to_file(episode_path)
		AudioPlayer.play_sfx(Database.SE_START)
	else:
		AudioPlayer.play_sfx(Database.SE_MENU_ERROR)


#===
func center():
	var focused_object = get_viewport().gui_get_focus_owner()
	if not focused_object in button_container.get_children(): return
	var index = focused_object.get_index()
	var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")/2
	#работает только если все элементы равны по размеру
	var pivot_offset = focused_object.size.x/2
	if index: pivot_offset += index*(focused_object.size.x + button_container.get_theme_constant("separation"))
	button_container.position.x = viewport_width - pivot_offset


#getters
func _get_title_screen() -> TitleScreen:
	var title_screen = get_parent()
	return title_screen if title_screen is TitleScreen else null
