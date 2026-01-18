@tool
extends TextureRect

@export var images: Array[Texture2D]:
	set(values): images = _set_images(values)

func _set_images(values):
	if not values.is_empty(): texture = values[0]
	return values

func update(index):
	if images.is_empty(): return
	texture = images[index] if index < images.size() else images[0]
