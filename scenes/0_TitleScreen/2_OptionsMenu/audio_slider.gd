class_name AudioSlider extends Slider

@export_enum("Master", "SFX", "Music", "Ambient") var audio_alias: String = "Music"

var bus_index:
	get(): return 0 if not audio_alias else AudioServer.get_bus_index(audio_alias)

var muted: bool:
	get(): return AudioServer.is_bus_mute(bus_index)


func _ready() -> void:
	value = AudioServer.get_bus_volume_linear(bus_index)
	
	value_changed.connect(func(linear_value):
		if not audio_alias: return
		AudioServer.set_bus_volume_linear(bus_index, linear_value)
	)
	
func update() -> void: value = AudioServer.get_bus_volume_db(bus_index)
