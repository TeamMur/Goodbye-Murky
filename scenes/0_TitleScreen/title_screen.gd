class_name TitleScreen extends Node
static var alias: String = "title_screen"


@onready var main_menu:      Control = $MainMenu
@onready var options_menu:   Control = $OptionsMenu
@onready var episode_menu:   Control = $EpisodeMenu


func _ready() -> void:
	change_screen_to_main_menu()


#===
func _change_screen_to(node) -> void:
	_deactivate_all()
	_activate_node(node)

func change_screen_to_main_menu()    -> void: _change_screen_to(main_menu)
func change_screen_to_options_menu() -> void: _change_screen_to(options_menu)
func change_screen_to_episode_menu() -> void: _change_screen_to(episode_menu)


#switch
func _activate_node(node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node._choised()
	node.show()

func _deactivate_node(node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()

func _deactivate_all() -> void:
	for child in get_children(): _deactivate_node(child)
