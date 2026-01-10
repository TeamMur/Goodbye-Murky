class_name EpisodeMenu extends Node
static var alias: String = "episode_menu"


#===
func _ready() -> void:
	if get_tree().current_scene == self: _choised()
	
	_connect_signals()

func _choised() -> void:
	_button_focus_grab(1)
	AudioPlayer.music.stop()

#===
func _try_to_call(event, callable) -> void:
	var is_just_pressed = event.is_pressed() and not event.is_echo()
	var is_accept_key = event is InputEventKey and event.keycode in [KEY_ENTER, KEY_Z] 
	if is_just_pressed and is_accept_key: callable.call()

func _get_title_screen() -> TitleScreen:
	var title_screen = get_parent()
	return title_screen if title_screen is TitleScreen else null

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
	_update_episode_title(index)
	preview.texture = images[index] if index < images.size() else null

func _on_button_focus_exited(button) -> void:
	button.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	button.remove_theme_color_override("font_color")

func _on_return_button_pressed() -> void:
	var title_screen = _get_title_screen()
	if title_screen: title_screen.change_screen_to_main_menu()
	AudioPlayer.play_sfx(Database.SE_MENU_BACK)

func _on_level_button_pressed(button) -> void:
	var index = button.get_index()
	var episode_path = episode_pattern % index
	
	if FileAccess.file_exists(episode_path):
		get_tree().change_scene_to_file(episode_path)
		AudioPlayer.play_sfx(Database.SE_START)
	else:
		AudioPlayer.play_sfx(Database.SE_MENU_ERROR)


#===
##tiso
func center():
	var focused_object = get_viewport().gui_get_focus_owner()
	if not focused_object in button_container.get_children(): return
	var index = focused_object.get_index()
	var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")/2
	#работает только если все элементы равны по размеру
	var pivot_offset = focused_object.size.x/2
	if index: pivot_offset += index*(focused_object.size.x + button_container.get_theme_constant("separation"))
	button_container.position.x = viewport_width - pivot_offset


func _update_episode_title(index):
	episode_title.text = titles[index] if index < titles.size() else "🔏"
	if index >= unlocked_level: episode_title.text = "🔏"

#===
@onready var button_container: BoxContainer = $ButtonContainer
@onready var return_button: Label = $ButtonContainer/ReturnButton
@onready var preview: TextureRect = $Preview

const image_1 = null
const image_2 = preload("uid://bkmsl75e5ymio")
const image_3 = preload("uid://dmu6d2oagulwa")
const image_4 = preload("uid://b27oysvg2pppn")
const image_5 = preload("uid://xmmy3psvd00s")
const image_6 = preload("uid://54ekw3a34wie")

var images = [image_1, image_2, image_3, image_4, image_5, image_6]
var episode_pattern = "res://scenes/1_EpisodeScreen/Episode_%d.tscn"


@onready var episode_title: Label = $EpisodeTitle
var titles = ["", "Вступление", "Начало", "История", "Завершение", "Конец", "Бонус"]
var unlocked_level = images.size()
