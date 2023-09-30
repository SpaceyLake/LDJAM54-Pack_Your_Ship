extends Node

enum ComponentType {
	NONE,
	ENGINE,
	FUELCELL,
	WEAPON,
	AMMO,
	CARGO
}

var camera = null

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func screen_shake(strength: float) -> void:
	if camera != null:
		camera.apply_shake(strength)
