extends Node2D
class_name TargetingComponent2D

@export var target: Node2D
@export var seeker: Node2D
@export var rotation_speed: float
@export var debug: bool = false

func _process(delta):
	if debug:
		rotate_towards_mouse(delta)

func rotate_towards_target(delta: float):
	if target != null:
		var target_angle = seeker.global_position.angle_to_point(target.global_position)
		var _diff = target_angle - seeker.global_rotation
		_diff = wrap(_diff, -PI, PI)
		seeker.global_rotation += sign(_diff) * min(rotation_speed * delta, abs(_diff))

func rotate_towards_mouse(delta):
	var target_angle = seeker.global_position.angle_to_point(get_global_mouse_position())
	var _diff = target_angle - seeker.global_rotation
	_diff = wrap(_diff, -PI, PI)
	seeker.global_rotation += sign(_diff) * min(rotation_speed * delta, abs(_diff))
