extends BoxContainer

@onready var up_container: BoxContainer = $UpContainer
@onready var down_container: BoxContainer = $DownContainer
@onready var left_container: BoxContainer = $LeftContainer
@onready var right_container: BoxContainer = $RightContainer
@onready var accept_container: BoxContainer = $AcceptContainer
@onready var cancel_container: BoxContainer = $CancelContainer
@onready var guide_container: BoxContainer = $GuideContainer
@onready var pause_container: BoxContainer = $PauseContainer

@onready var return_button: BoxContainer = $ReturnContainer

#===
func _ready() -> void:
	_connect_signals()
	
	for container in get_children():
		if container is  BoxContainer:
			if container == return_button: continue
			var symbol: Label = container.get_node("Value")
			var path: NodePath = symbol.get_path()
			symbol.focus_neighbor_top = path
			symbol.focus_neighbor_bottom = path
			symbol.focus_neighbor_left = path
			symbol.focus_neighbor_right = path
			symbol.focus_next = path
			symbol.focus_previous = path

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
		if container is  BoxContainer:
			if container == return_button: continue
			container.gui_input.connect(_try_to_call.bind(_on_control_button_pressed.bind(container)))
			var symbol = container.get_node("Value")
			symbol.gui_input.connect(_on_symbol_gui_input.bind(symbol))
			symbol.focus_entered.connect(_on_symbol_focus_entered.bind(symbol))
			symbol.focus_exited.connect(_on_symbol_focus_exited.bind(symbol))
	
	return_button.gui_input.connect(_try_to_call.bind(_on_return_button_pressed))
	
	for button: BoxContainer in get_children():
		button.focus_entered.connect(_on_button_focus_entered.bind(button))
		button.focus_exited.connect(_on_button_focus_exited.bind(button))

func _button_focus_grab(index = 0) -> void:
	get_child(index).grab_focus.call_deferred()

func _on_button_focus_entered(box: BoxContainer) -> void:
	box.get_node("Title").add_theme_color_override("font_color", Color.BLACK)
	AudioPlayer.play_sfx(Database.SE_MENU_HOVER)
	center()

func _on_button_focus_exited(box: BoxContainer) -> void:
	box.get_node("Title").remove_theme_color_override("font_color")

func _on_control_button_pressed(button):
	button.get_node("Value").grab_focus.call_deferred()
	button.get_node("Title").add_theme_color_override.bind("font_color", Color.BLACK).call_deferred()

func _on_symbol_focus_entered(symbol: Control):
	symbol.add_theme_color_override.bind("font_color", Color.RED).call_deferred()

func _on_symbol_focus_exited(symbol: Control):
	symbol.remove_theme_color_override("font_color")

func _on_symbol_gui_input(event: InputEvent, symbol: Control):
	var is_just_pressed = event.is_pressed() and not event.is_echo()
	if not is_just_pressed or not symbol.has_focus(): return
	#работает однозначно для клавиатуры
	#поведение на других устройствах неизвестно
	var e: InputEventKey = event
	var string: String = OS.get_keycode_string(e.keycode)
	symbol.text = string
	symbol.get_parent().grab_focus.call_deferred()
	#ДОБАВИТЬ РЕАЛЬНУЮ СМЕНУ ДЕЙСТВИЯ В INPUT_MAP
	#я бы хотел сделать по 2 варианта раскладки, как быть?


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
