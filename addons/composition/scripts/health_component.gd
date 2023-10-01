extends Node
class_name HealthComponent

signal health_depleted
signal on_damage(damage)

@export var max_health: float = 10.0
@export var current_health: float

func damage(Damage:float):
	current_health -= Damage
	
	if current_health > max_health:
		current_health = max_health
	
	on_damage.emit(Damage)
	
	if current_health <= 0:
		health_depleted.emit()

func heal(Heal:float):
	damage(-Heal)
