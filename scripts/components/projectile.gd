extends Node2D
class_name Projectile

@export var attack: AttackComponent2D
@export var speed: float
@export var target: Vector2
@export var sprite: Sprite2D
@export var particel: GPUParticles2D
@export var timer:Timer

func _ready():
	attack.hit.connect(Callable(self,"on_hit"))
	timer.timeout.connect(Callable(self,"remove"))

func _process(delta):
	position += Vector2(1, 0) * speed * delta

func remove():
	queue_free()

func on_hit():
	timer.start(1)
	if sprite != null:
		sprite.visible = false
