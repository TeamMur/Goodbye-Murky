class_name AudioMaster extends Node
var alias: String = "audio_master"

@onready var sfx:     AudioStreamPlayer = get_node_or_null("SFX")
@onready var music:   AudioStreamPlayer = get_node_or_null("Music")
@onready var ambient: AudioStreamPlayer = get_node_or_null("Ambient")

func _ready() -> void:
	set_music_volume_linear(0.5)
	set_sound_volume_linear(0.5)


func play(player, path):
	var stream: Object = load(path) if path is String else path
	player.stream = stream
	player.play()

func play_music(path: Variant): play(music, path)
func play_ambient(path: Variant): play(ambient, path)
func play_sfx(path: Variant, override: bool = false):
	if override: play(sfx, path)
	else:
		var stream: Object = load(path) if path is String else path
		var sfx_prim: AudioStreamPlayer = sfx.duplicate()
		sfx_prim.stream = stream
		sfx_prim.autoplay = true
		
		var sfx_kill: Callable = func() -> void: sfx_prim.queue_free()
		sfx_prim.finished.connect(sfx_kill)
		
		add_child(sfx_prim)

func set_mute(bus_name: String, enable: bool = true) -> void:
	var index: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(index, enable)

func set_music_volume_linear(value):
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(bus_index, value)

func set_sound_volume_linear(value):
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_linear(bus_index, value)
