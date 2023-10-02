extends Area2D

var mouse_on:bool = false
var mouse_position:Vector2
var holding:bool = false
var held_offset:Vector2
var previous_position
@export var parent:StructureComponent #= get_parent()
var shadow:StructureComponent

func is_held():
	return holding

func _input(event):
	if event is InputEventMouseMotion:
		mouse_position = event.position
		if holding:
			shadow.global_position = mouse_position - held_offset
	if event is InputEventMouseButton and event.is_pressed() and mouse_on and event.button_index == MOUSE_BUTTON_LEFT:
		previous_position = parent.global_position
		held_offset = mouse_position - parent.global_position
		shadow = parent.duplicate()
		add_child(shadow)
		holding = true
		shadow.global_position = mouse_position - held_offset
		shadow.modulate = 0xFFFFFF7F
		shadow.set_process(false)
	if event is InputEventMouseButton and not event.is_pressed() and holding and event.button_index == MOUSE_BUTTON_LEFT:
		parent.place(shadow.global_position)
		holding = false
		shadow.queue_free()

func _on_mouse_entered():
	mouse_on = true

func _on_mouse_exited():
	mouse_on = false
