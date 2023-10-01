extends Node2D
class_name Enemy

var goal:Vector2
signal enemy_killed_signal(enemy)

@export var health: HealthComponent

func _ready():
	health.health_depleted.connect(Callable(self, "on_death"))

func setup(new_goal:Vector2):
	self.goal = new_goal

func on_death():
	enemy_killed_signal.emit(self)
