extends Node2D

func _ready():
	$laser/TargetingComponent2D.target = $Target
