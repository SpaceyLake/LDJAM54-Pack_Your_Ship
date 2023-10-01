extends Node2D
class_name Projectile

@export var attack: AttackComponent2D
@export var speed: float
@export var target: Vector2
@export var sprite: Sprite2D
@export var particel_trail: GPUParticles2D
@export var particel_explode: GPUParticles2D
@export var timer:Timer

func _ready():
	attack.hit.connect(Callable(self,"on_hit"))
	timer.timeout.connect(Callable(self,"remove"))
	timer.start(20)

func _process(delta):
	position += target.normalized() * speed * delta

func remove():
	queue_free()

func on_hit():
	timer.start(1)
	if particel_trail != null:
		particel_trail.set_emitting(false)
	if particel_explode != null:
		particel_explode.restart()
		particel_explode.set_emitting(true)
	if sprite != null:
		sprite.visible = false
	attack.set_deferred("monitoring", false)
