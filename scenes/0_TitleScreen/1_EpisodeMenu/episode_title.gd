extends Label


@export var titles: Array[String]

@export var locked_symbol = "🔏"

func update(index):
	text = titles[index] if index < titles.size() else locked_symbol
	if index >= Savebase.last_unlocked_level: text = locked_symbol
