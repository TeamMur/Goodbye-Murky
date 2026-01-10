extends Node
static var alias: String = "Effects"

@onready var abberation: ColorRect = $Abberation
@onready var noise: ColorRect = $Noise

signal abberation_changed
signal noise_changed

func abberation_on():
	abberation.show()
	abberation_changed.emit(true)

func abberation_off():
	abberation.hide()
	abberation_changed.emit(false)

func noise_on():
	noise.show()
	noise_changed.emit(true)

func noise_off():
	noise.hide()
	noise_changed.emit(false)
