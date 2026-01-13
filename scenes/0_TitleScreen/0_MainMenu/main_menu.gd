class_name MainMenu extends Node
static var alias: String = "main_menu"


@onready var button_container: BoxContainer = $ButtonContainer
@onready var play_button:      Label        = $ButtonContainer/PlayButton
@onready var episode_button:   Label        = $ButtonContainer/EpisodeButton
@onready var options_button:   Label        = $ButtonContainer/OptionsButton
@onready var exit_button:      Label        = $ButtonContainer/ExitButton


#===
func _ready() -> void:
	_connect_signals()

func _choised() -> void:
	_button_focus_grab()
	AudioPlayer.play_music(Database.MAIN_MENU_MUSIC)


#===
func _try_to_call(event: InputEvent, callable: Callable) -> void:
	var is_just_pressed = event.is_pressed() and not event.is_echo()
	var is_accept_key = event.is_action("z")
	if is_just_pressed and is_accept_key: callable.call()


#signals
func _connect_signals() -> void:
	play_button.gui_input.connect(_try_to_call.bind(_on_play_button_pressed))
	episode_button.gui_input.connect(_try_to_call.bind(_on_episode_button_pressed))
	options_button.gui_input.connect(_try_to_call.bind(_on_options_button_pressed))
	exit_button.gui_input.connect(_try_to_call.bind(_on_exit_button_pressed))
	
	for button: Label in button_container.get_children():
		button.focus_entered.connect(_on_button_focus_entered.bind(button))
		button.focus_exited.connect(_on_button_focus_exited.bind(button))

func _button_focus_grab(index = 0) -> void:
	button_container.get_child(index).grab_focus.call_deferred()



#button effect
func _on_button_focus_entered(button: Label) -> void:
	button.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	button.add_theme_color_override("font_color", Color.BLACK)
	AudioPlayer.play_sfx(Database.SE_MENU_HOVER)

func _on_button_focus_exited(button: Label) -> void:
	button.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	button.remove_theme_color_override("font_color")


#button action
func _on_play_button_pressed() -> void:
	print("play button pressed, launch 1 episode by default")
	get_tree().change_scene_to_packed(Database.EPISODE_1)
	AudioPlayer.play_sfx(Database.SE_START)

func _on_episode_button_pressed() -> void:
	var title_screen = _get_title_screen()
	if title_screen: title_screen.change_screen_to_episode_menu()
	AudioPlayer.play_sfx(Database.SE_MENU_OPEN)

func _on_options_button_pressed() -> void:
	var title_screen = _get_title_screen()
	if title_screen: title_screen.change_screen_to_options_menu()
	AudioPlayer.play_sfx(Database.SE_MENU_OPEN)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

#getters
func _get_title_screen() -> TitleScreen:
	var title_screen = get_parent()
	return title_screen if title_screen is TitleScreen else null
