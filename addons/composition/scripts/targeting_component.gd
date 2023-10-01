extends Node2D
class_name TargetingComponent2D

signal ready_to_fire
signal not_ready_to_fire

@export var target: Node2D
@export var seeker: Node2D
@export var rotation_speed: float
@export var debug: bool = false
@export var sensitivity: float = 0.01

func _process(delta):
	if debug:
		rotate_towards_mouse(delta)

func get_rotation_needed(check_target: Node2D) -> float:
	var target_angle = seeker.global_position.angle_to_point(check_target.global_position)
	var _diff:float = target_angle - seeker.global_rotation
	return _diff*_diff

func rotate_towards_target(delta: float):
	if target != null:
		var target_angle = seeker.global_position.angle_to_point(target.global_position)
		var _diff = target_angle - seeker.global_rotation
		if _diff > -sensitivity and _diff < sensitivity:
			ready_to_fire.emit()
		else:
			not_ready_to_fire.emit()
		_diff = wrap(_diff, -PI, PI)
		seeker.global_rotation += sign(_diff) * min(rotation_speed * delta, abs(_diff))

func rotate_towards_mouse(delta):
	var target_angle = seeker.global_position.angle_to_point(get_global_mouse_position())
	var _diff = target_angle - seeker.global_rotation
	_diff = wrap(_diff, -PI, PI)
	seeker.global_rotation += sign(_diff) * min(rotation_speed * delta, abs(_diff))
