extends Area2D
class_name AttackComponent2D

signal hit

@export var attack: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", Callable(self, "area_entered"))

func area_entered(area: Area2D):
	if area.has_method("damage"):
		area.damage(attack)
		hit.emit()
