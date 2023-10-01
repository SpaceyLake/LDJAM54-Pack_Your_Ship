extends Node

enum ComponentType {
	NONE,
	ENGINE,
	FUELCELL,
	WEAPON,
	AMMO,
	CARGO
}

var camera: Camera = null
var popup: PopupDialog = null

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func screen_shake(strength: float) -> void:
	if camera != null:
		camera.apply_shake(strength)

func popup_queue_test(text):
	if popup != null:
		popup.queue_text(text)
