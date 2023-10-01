extends Node

enum ComponentType {
	NONE,
	ENGINE,
	FUELCELL,
	WEAPON,
	AMMO,
	CARGO
}

var camera:Camera = null
var shake = true
var sound:float = 1.0
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func load_settings():
	var content = []
	var file = FileAccess.open("user://options.dat", FileAccess.READ)
	if file != null:
		content = file.get_as_text().split(":")
		print(content)
		file.close()
		shake = true if (content[0] == "true") else false
		sound = float(content[1])

func screen_shake(strength: float) -> void:
	if camera != null and shake:
		camera.apply_shake(strength)
