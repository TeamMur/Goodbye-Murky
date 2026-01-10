extends Node2D

@onready var pivot: Marker2D = $Pivot

func _ready() -> void:
	var kach = func():
		if pivot.position == Vector2.ZERO:
			var random_bias = Vector2(randi_range(-1, 1), randi_range(-1, 1))
			pivot.position += random_bias
		else:
			pivot.position = Vector2.ZERO
	
	var t = create_tween().set_loops()
	t.tween_callback(kach).set_delay(0.3)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"): up()
	if Input.is_action_just_pressed("ui_down"): down()

var up_position = 0
var down_position = 144

var tween

func up():
	var method = func(value):
		var val = int(value) 
		if val % 1 == 0: position.y = val
	tween = create_tween()
	tween.tween_method(method, position.y, up_position, 1).set_ease(Tween.EASE_OUT_IN)


func down():
	var method = func(value):
		var val = int(value) 
		if val % 1 == 0: position.y = val
	tween = create_tween()
	tween.tween_method(method, position.y, down_position, 1).set_ease(Tween.EASE_OUT_IN)

func launch():
	pass

func run_level():
	pass
