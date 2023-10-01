extends Node2D
class_name Enemy

var goal:Vector2
var target:StructureComponent
var spaceship:SpaceShip
signal enemy_killed_signal(enemy)

@export var hurtbox: HurtboxComponent2D
@export var health: HealthComponent
@export var fire_audio: AudioStreamPlayer
@export var death_audio: AudioStreamPlayer

func _ready():
	health.health_depleted.connect(on_death)

func setup(new_goal:Vector2, new_spaceship:SpaceShip):
	self.goal = new_goal
	self.spaceship = new_spaceship

func on_death():
	hurtbox.set_deferred("monitorable", false)
	hurtbox.set_deferred("monitoring", false)
	set_process(false)
	set_visible(false)
	enemy_killed_signal.emit(self)
	death_audio.finished.connect(remove)
	death_audio.play(0)

func remove():
	queue_free()
