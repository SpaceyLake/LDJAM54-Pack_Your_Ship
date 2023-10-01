extends Node2D

var simultaneous_scene = preload("res://test.tscn").instantiate()

func _on_start_button_button_up():
	get_tree().root.add_child(simultaneous_scene)
	get_node("/root/start_screen").queue_free()


func _on_quit_button_button_up():
	get_tree().quit()
