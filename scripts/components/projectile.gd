extends Node2D
class_name Projectile

@export var attack: AttackComponent2D
@export var speed: float
@export var target: Vector2
@export var sprite: Sprite2D
@export var particel: GPUParticles2D

func _ready():
	target = (target - global_position).normalized() * speed
	attack.hit.connect(Callable(self,"on_hit"))

func on_hit():
	queue_free()
