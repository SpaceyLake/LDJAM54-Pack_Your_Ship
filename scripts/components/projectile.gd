extends Node2D
class_name Projectile

@export var attack: AttackComponent2D
@export var speed: float
@export var target: Vector2
@export var sprite: Sprite2D
@export var particel: GPUParticles2D

func _ready():
	attack.hit.connect(Callable(self,"on_hit"))

func _process(delta):
	position += Vector2(1, 0) * speed * delta

func on_hit():
	queue_free()
