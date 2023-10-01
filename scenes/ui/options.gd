extends Node2D

@onready var shake = $CheckButtonScreenshake
@onready var sound = $SoundSlider


func _ready():
	load_file()

func load_file():
	var content = []
	var file = FileAccess.open("user://options.dat", FileAccess.READ)
	if file != null:
		content = file.get_as_text().split(":")
		print(content)
		file.close()
		shake.button_pressed = true if (content[0] == "true") else false
		sound.value = float(content[1])


func save_file():
	var content = str(shake.button_pressed)+":"+str(sound.value)
	var file = FileAccess.open("user://options.dat", FileAccess.WRITE)
	file.store_string(content)
	file.close()

func _on_save_button_button_up():
	save_file()
	Global.load_settings()
	queue_free()


func _on_close_button_button_up():
	queue_free()
