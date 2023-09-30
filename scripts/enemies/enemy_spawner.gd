extends Node

@export_range(0, 1, 0.001) var spawnrate:float = 0

@onready var spawn_timer = $SpawnTimer
var rng = RandomNumberGenerator.new()

func _ready():
	spawn_timer.start(rng.randf_range(2 * spawnrate, 100 * spawnrate))


func _on_spawn_timer_timeout():
	
	spawn_timer.start(rng.randf_range(2 * spawnrate, 100 * spawnrate))
