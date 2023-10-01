extends Node2D

var simultaneous_scene = preload("res://test.tscn")
var options = preload("res://scenes/ui/options.tscn")

func _ready():
	Global.load_settings()

func _on_start_button_button_up():
	get_tree().root.add_child(simultaneous_scene.instantiate())
	get_node("/root/start_screen").queue_free()


func _on_quit_button_button_up():
	get_tree().quit()


func _on_options_button_button_up():
	get_tree().root.add_child(options.instantiate())
