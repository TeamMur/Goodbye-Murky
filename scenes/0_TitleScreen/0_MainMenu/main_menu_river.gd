@tool
class_name River extends Control
static var alias: String = "river"


@onready var part_1: TextureRect = $part1
@onready var part_2: TextureRect = $part2

@export_range(0.05, 1, 0.05) var update_time = 0.3
@export_range(1, 8, 1) var move_range = 2

var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var current_image_index = 0

var tween: Tween


#tween
func _ready() -> void:
	_reset()
	_update_images()
	if not Engine.is_editor_hint():
		_add_tween()

func _move():
	var new_position = position.x - move_range
	
	if new_position <= -viewport_width:
		new_position = 0
		
		current_image_index += 1
		if current_image_index >= images.size(): current_image_index = 0
		
		part_1.texture = part_2.texture
		part_2.texture = images[current_image_index]
	
	position.x = new_position

#editor
func _add_tween():
	_kill_tween()
	tween = create_tween().set_loops()
	tween.tween_callback(_move).set_delay(update_time)

func _kill_tween(): if tween: tween.kill(); tween = null

func _update_tween():
	_kill_tween()
	call_deferred("_add_tween")

func _reset():
	position = Vector2.ZERO


#setget vars 
@export var images: Array[Texture2D]:
	set(values): images = _set_images(values)

@export var move_in_editor: bool = false:
	set(value):
		if not Engine.is_editor_hint(): return
		move_in_editor = value
		if move_in_editor: call_deferred("_add_tween")
		else: _kill_tween(); _reset()

#setters and getters
func _set_images(values):
	if not values.is_empty():
		if values[0] and part_1 and part_1.texture != values[0]: part_1.texture = values[0]
		if values[1] and part_2 and part_2.texture != values[1]: part_2.texture = values[1]
	return values

func _update_images(): images = images
