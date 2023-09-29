extends Node
class_name HealthComponent

signal health_depleted

@export var max_health: float = 10.0
var current_health: float

func damage(Damage:float):
	current_health -= Damage
	
	if current_health > max_health:
		current_health = max_health
	
	if current_health <= 0:
		health_depleted.emit()

func heal(Heal:float):
	damage(-Heal)
