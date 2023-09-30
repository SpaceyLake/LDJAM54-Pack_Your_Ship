extends Node

enum tile_type {NORMAL, ENGINE, WEAPON, UNI}

var camera = null

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func screen_shake(strength: float) -> void:
	if camera != null:
		camera.apply_shake(strength)
