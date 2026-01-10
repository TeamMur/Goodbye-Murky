extends AnimatedSprite2D


@onready var ray_cast: RayCast2D = $RayCast


func _input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_echo():
		if event is InputEventKey:
			ray_cast.target_position = Vector2.ZERO
			match event.keycode:
				KEY_LEFT:
					ray_cast.target_position.x = -12
				KEY_RIGHT:
					ray_cast.target_position.x = 12
				KEY_UP:
					ray_cast.target_position.y = -12
				KEY_DOWN:
					ray_cast.target_position.y = 12
			
			call_deferred("move", ray_cast.target_position)
			print()
			
			

func move(vector):
	if not ray_cast.is_colliding(): position += vector
