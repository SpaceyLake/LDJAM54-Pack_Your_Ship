extends Enemy

@export var velocity = 500

func _process(delta):
	global_rotation = (goal - global_position).angle()
	global_position = global_position.move_toward(goal, velocity*delta)
