extends Enemy

@export var velocity = 500

func _process(delta):
	if global_position != goal:
		global_rotation = (goal - global_position).angle()
		global_position = global_position.move_toward(goal, velocity*delta)
	else:
		global_rotation = (target - global_position).angle()


