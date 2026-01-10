class_name Typer extends RichTextLabel
var alias: String = "typer"


#===_set
var unison: String = "res://assets/audio/button_switch.mp3"
func _set(variable, value):
	if unison != "" and variable == "visible_characters":
		var changed = visible_characters != value
		var is_frequency_matches = value % frequency == 0
		if changed and is_frequency_matches: ST_AudioMaster.play_sfx(unison, true)

func _init() -> void: bbcode_enabled = true

#===_input
signal key_responce
signal key_pressed
var responce_time = 0.5

func _input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_echo():
		if event is InputEventKey and event.keycode == KEY_Z:
			key_pressed.emit()

func responce() -> void:
	key_responce.emit()
	var responce_timer = get_tree().create_timer(responce_time)
	responce_timer.timeout.connect(_test_response_ux)
	await responce_timer.timeout
	await key_pressed

func _test_response_ux(): text += " [z]"; visible_characters = text.length()

#=== type
var frequency: int = 2
var tween: Tween
var timer: SceneTreeTimer

var functions = {
	"/empty": empty,
	"/responce": responce
}

func type(array: Array) -> void: 
	for el in array:
		if   el is String:
			if el[0] == "/": await functions[el].call()
			else: await add(el)
		elif el is Array:              await add(el[0], el[1])
		elif el is float or el is int: await delay(el)


func add(part: String, cps: float = 24.0):
	text += part
	var part_final_length = part.length()-bbcode_length(part)
	var text_final_length = text.length() - bbcode_length(text)
	var time: float = part_final_length / cps
	
	tween = create_tween()
	tween.tween_property(self, "visible_characters", text_final_length, time)
	await tween.finished

func backspace(count: Variant = 1, cps: float = 24.0) -> void:
	if count is String: count = count.length()
	
	var time: float = count / cps
	var text_final_length: int = text.length() - bbcode_length(self.text)
	var erased_text_length: int = text_final_length - count
	
	tween = create_tween()
	tween.tween_property(self, "visible_characters", erased_text_length, time)
	await tween.finished
	
	remove(count)

func remove(count: Variant = 1):
	if count is String: count = count.length()
	
	var from = text.length() - count
	text = text.erase(from, count)
	var text_final_length = text.length() - bbcode_length(self.text)
	visible_characters = text_final_length

func delay(time: float) -> void: await get_tree().create_timer(time).timeout
func empty() -> void: text = ""; visible_characters = 0
func set_frequency(value) -> void: frequency = value

#=== service
func bbcode_length(string: String) -> int:
	var tag_stack := []
	var length: int = 0
	
	for i in range(string.length()):
		if string[i] == "/":
			var end = string.find("]", i-1)
			var end_word: String 
			if end != -1:
				var tag = string.substr(i+1, end - i - 1)
				tag_stack.append("[/" + tag + "]")
				end_word = tag
			
			var start = string.rfind("[" + end_word, end)
			if start != -1:
				end = string.find("]", start)
				var tag = string.substr(start, end - start + 1)
				tag_stack.append(tag)
		
	for tag in tag_stack: length += tag.length()
	return length
