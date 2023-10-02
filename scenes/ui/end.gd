extends Node2D


func _on_restart_pressed():
	get_tree().current_scene = get_parent()
	get_tree().reload_current_scene()

func set_score(score):
	$Label.text += str(score)
