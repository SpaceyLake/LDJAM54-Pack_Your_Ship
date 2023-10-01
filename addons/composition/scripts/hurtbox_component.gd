extends Area2D
class_name HurtboxComponent2D

@export var health_component: HealthComponent

func damage(Attack: float):
	if health_component:
		health_component.damage(Attack)
	else:
		print(name + ": No HealthComponent selected " + get_parent().name)
