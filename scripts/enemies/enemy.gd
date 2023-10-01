extends Node2D
class_name Enemy

var goal:Vector2
var target:StructureComponent
var spaceship:SpaceShip
signal enemy_killed_signal(enemy)

@export var health: HealthComponent
@export var audio: AudioStreamPlayer

func _ready():
	health.health_depleted.connect(on_death)

func setup(new_goal:Vector2, new_spaceship:SpaceShip):
	self.goal = new_goal
	self.spaceship = new_spaceship

func on_death():
	enemy_killed_signal.emit(self)
