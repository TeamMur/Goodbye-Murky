class_name River extends Control
static var alias: String = "river"


func _ready() -> void:
	_connect_signals()


#===
func _connect_signals() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	var new_position = position.x - 2
	var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	
	if new_position <= -viewport_width:
		new_position = 0
		
		current_image_index += 1
		if current_image_index >= images.size(): current_image_index = 0
		
		part_1.texture = part_2.texture
		part_2.texture = images[current_image_index]
	
	position.x = new_position



#===
@onready var part_1: TextureRect = $part1
@onready var part_2: TextureRect = $part2

@onready var timer: Timer = $Timer

const image_1 = preload("uid://cgt33ggxkekgv")
const image_2 = preload("uid://bkmsl75e5ymio")
const image_3 = preload("uid://dmu6d2oagulwa")
const image_4 = preload("uid://b27oysvg2pppn")
const image_5 = preload("uid://xmmy3psvd00s")
const image_6 = preload("uid://54ekw3a34wie")

var images = [image_1, image_2, image_3, image_4, image_5, image_6]
var current_image_index = 1
