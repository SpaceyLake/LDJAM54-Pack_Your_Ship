extends Node2D
class_name VelocityComponent2D

@export var max_speed: float = 10.0
@export var acceleration_coefficient: float = 0.1
@export var debug: bool = false

var velocity: Vector2
var acceleration_coefficient_multiplier: float = 1.0
var speed_multiplier: float = 1.0

func _ready():
	velocity = Vector2.ZERO

#func _process(delta):
#	AccelerateToVelocity(Vector2(-100,100))

func accelerate_to_velocity(Velocity:Vector2):
	velocity = velocity.lerp(Velocity, min(acceleration_coefficient*acceleration_coefficient_multiplier*speed_procent(),1.0))

func get_max_velocity(Direction:Vector2):
	return Direction * max_speed * speed_multiplier

func maximize_velocity(Direction:Vector2):
	velocity = get_max_velocity(Direction)

func decelerate():
	accelerate_to_velocity(Vector2.ZERO)

func move(CharacterBody:CharacterBody2D):
	CharacterBody.velocity = velocity
	CharacterBody.move_and_slide()

func set_max_speed(Speed:float):
	max_speed = Speed

func calculated_max_speed():
	return max_speed * speed_multiplier

func speed_procent():
	return min((calculated_max_speed()-velocity.length()) / calculated_max_speed(), 1.0)

func debug_draw(Owner:Node2D):
	draw_line(Vector2.ZERO, velocity, Color.MAGENTA, 2.0)
