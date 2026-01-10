class_name AudioSlider extends Slider
var alias: String = "audio_slider"

@export_enum("Master", "SFX", "Music", "Ambient") var bus_name: String = "Music"

func _ready() -> void:
	update()
	value_changed.connect(func(val): Options.set_bus_volume_linear(bus_name, val))

func update() -> void: value = Options.get_bus_volume_linear(bus_name)
