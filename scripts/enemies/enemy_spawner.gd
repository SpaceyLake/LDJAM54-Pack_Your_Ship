extends Node

signal enemy_killed(enemy:Enemy)

@export_range(0, 1, 0.001) var spawnrate:float = 0
@export var enemy_scenes:Array[PackedScene]
@export var enemy_likeliness:Array[float]
@export var space_ship:SpaceShip

@onready var spawn_timer = $SpawnTimer

var rng = RandomNumberGenerator.new()
var enemies:Array[Enemy]
var total_likeliness = 0

func _ready():
	for i in enemy_likeliness.size():
		total_likeliness += enemy_likeliness[i]
		enemy_likeliness[i] = total_likeliness
	spawn_timer.start(rng.randf_range(5 * spawnrate, 15 * spawnrate))


func _on_spawn_timer_timeout():
	get_viewport().size
	var spawnside = rng.randi_range(0, 2)
	var position = Vector2.ZERO
	if spawnside == 0:
		position.y = -32
		position.x = randi_range(-32, get_viewport().size.x/2)
	elif spawnside == 1:
		position.x = -32
		position.y = randi_range(-32, get_viewport().size.y + 32)
	elif spawnside == 2:
		position.y = get_viewport().size.y + 32
		position.x = randi_range(-32, get_viewport().size.x/2)
	var goal = Vector2.ZERO
	goal.x = randi_range(32, get_viewport().size.x - 32)
	goal.y = randi_range(32, get_viewport().size.y - 32)
	var rnd_enemy = rng.randi_range(0, total_likeliness - 1)
	var enemy:Enemy
	for i in enemy_likeliness.size():
		if rnd_enemy <= enemy_likeliness[i]:
			enemy = enemy_scenes[i].instantiate()
			add_child(enemy)
			enemy.global_position = position
			enemy.setup(goal, enemy_killed)
			enemies.append(enemy)
			break
	print("Spawned")
	print(position)
	print(goal)
	spawn_timer.start(rng.randf_range(5 * spawnrate, 15 * spawnrate))


func _on_enemy_killed(enemy:Enemy):
	enemies.erase(enemy)
	enemy.queue_free()
