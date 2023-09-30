extends Enemy

@export var velocity = 5

func _process(delta):
	global_position = global_position.move_toward(goal, velocity)
