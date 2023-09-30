@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("HealthComponent", "Node", preload("scripts/health_component.gd"), preload("res://icon.svg"))
	add_custom_type("HurtboxComponent2D", "Area2D", preload("scripts/hurtbox_component.gd"), preload("res://icon.svg"))
	add_custom_type("VelocityComponent2D", "Node2D", preload("scripts/velocity_component.gd"), preload("res://icon.svg"))
	add_custom_type("PathfindComponent2D", "Node2D", preload("scripts/pathfind_component.gd"), preload("res://icon.svg"))
	add_custom_type("ShadowComponent2D", "Node2D", preload("scripts/shadow_component.gd"), preload("res://icon.svg"))
	add_custom_type("AttackComponent2D", "Area2D", preload("scripts/attack_component.gd"), preload("res://icon.svg"))
	add_custom_type("SpawnerComponent2D", "Node2D", preload("scripts/spawner_component.gd"), preload("res://icon.svg"))
	add_custom_type("AOEComponent2D", "Area2D", preload("scripts/aoe_component.gd"), preload("res://icon.svg"))
	add_custom_type("TargetingComponent2D", "Node2D", preload("scripts/targeting_component.gd"), preload("res://icon.svg"))


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("HealthComponent")
	remove_custom_type("HurtboxComponent2D")
	remove_custom_type("VelocityComponent2D")
	remove_custom_type("PathfindComponent2D")
	remove_custom_type("ShadowComponent2D")
	remove_custom_type("AttackComponent2D")
	remove_custom_type("SpawnerComponent2D")
	remove_custom_type("AOEComponent2D")
	remove_custom_type("TargetingComponent2D")
