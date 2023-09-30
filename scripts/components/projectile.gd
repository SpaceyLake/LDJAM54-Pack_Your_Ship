extends CharacterBody2D
class_name Projectile

@export var attack: float
@export var speed: float
@export var target: Vector2
@export var velocity_comp: VelocityComponent2D
@export var sprite: Sprite2D
@export var particel: GPUParticles2D


func move_towards_target():
	pass
