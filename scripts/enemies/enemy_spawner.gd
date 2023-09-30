extends Node

@export_range(0, 1, 0.001) var spawnrate:float = 0
@export var enemy_scenes:Array[PackedScene]
@export var enemy_likeliness:Array[float]
@export var space_ship:SpaceShip

@onready var spawn_timer = $SpawnTimer
var rng = RandomNumberGenerator.new()
var enemies:Array[Enemy]

func _ready():
	spawn_timer.start(rng.randf_range(2 * spawnrate, 100 * spawnrate))


func _on_spawn_timer_timeout():
	get_viewport().size
	var spawnside = rng.randi_range(0, 2)
	var position = Vector2.ZERO
	if spawnside == 0:
		position.y = -32
		position.x = randi_range(-32, get_viewport().x/2)
	elif spawnside == 1:
		position.x = -32
		position.y = randi_range(-32, get_viewport().y + 32)
	elif spawnside == 2:
		position.x = get_viewport().size.y + 32
		position.x = randi_range(-32, get_viewport().x/2)
	spawn_timer.start(rng.randf_range(2 * spawnrate, 100 * spawnrate))
