extends Node

@export_range(0, 1, 0.001) var spawnrate:float = 0
@export var enemy_scenes:Array[PackedScene]
@export var enemy_likeliness:Array[float]
@export var space_ship:SpaceShip

@onready var spawn_timer = $SpawnTimer
@onready var spaceship:SpaceShip = get_parent().get_node("Spaceship")

var rng = RandomNumberGenerator.new()
var enemies:Array[Enemy]
var total_likeliness = 0

func _ready():
	for i in enemy_likeliness.size():
		total_likeliness += enemy_likeliness[i]
		enemy_likeliness[i] = total_likeliness
	spawn_timer.start(rng.randf_range(5 * spawnrate, 15 * spawnrate))


func _on_spawn_timer_timeout():
	var spawnside = rng.randi_range(0, 2)
	var position = Vector2.ZERO
	if spawnside == 0:
		position.y = - 32 - get_viewport().get_visible_rect().size.y/2
		position.x = randi_range(-32 - get_viewport().get_visible_rect().size.x/2, 0)
	elif spawnside == 1:
		position.x = -32 - get_viewport().get_visible_rect().size.x/2
		position.y = randi_range(-32 - get_viewport().get_visible_rect().size.y/2 , get_viewport().get_visible_rect().size.y / 2 + 32)
	elif spawnside == 2:
		position.y = 32 + get_viewport().size.y/2
		position.x = randi_range(-32 - get_viewport().get_visible_rect().size.x/2, 0)
	var goal = Vector2.ZERO
	goal.x = position.x + randi_range(96, get_viewport().get_visible_rect().size.x/2 - 96 - position.x)
	if position.y > spaceship.global_position.y:
		goal.y = randi_range(int(spaceship.global_position.y) - 90, get_viewport().get_visible_rect().size.y/2 + 96)
	else:
		goal.y = randi_range(-get_viewport().get_visible_rect().size.y/2 - 96, int(spaceship.global_position.y) + 90)
	position += Global.camera.global_position
	goal += Global.camera.global_position
	var tries = 0
	var original_goal = goal
	for other_enemy in enemies:
		if goal.distance_squared_to(other_enemy.goal) < 64*64:
			if goal.x > (get_viewport().get_visible_rect().size.x/2 + Global.camera.global_position.x) - 96:
				goal.x -= 64
			elif goal.x < 96:
				goal.x -= 64
			else:
				goal.x += 64 * sign(float(rng.randi_range(0, 1)) - 0.5)
	while spaceship.crosses_ship(position, goal):
		if tries < 5:
			goal.y = move_toward(goal.y, position.y, 32)
		elif tries < 10:
			goal.y = move_toward(goal.x, position.x, 32)
		else:
			goal = original_goal
			position = original_goal + Vector2(-rng.randi_range(96, -get_viewport().get_visible_rect().size.x/2 + original_goal.x), (get_viewport().get_visible_rect().size.y/2 + 96)*sign(original_goal.y - spaceship.global_position.y))
		tries += 1
	while spaceship.on_ship(goal):
		goal.y += move_toward(goal.y, position.y, 90)
	var target = spaceship.get_closest_component_position(goal)
	if target == null:
		target = goal
	var rnd_enemy = rng.randi_range(0, total_likeliness - 1)
	var enemy:Enemy
	for i in enemy_likeliness.size():
		if rnd_enemy <= enemy_likeliness[i]:
			enemy = enemy_scenes[i].instantiate()
			add_child(enemy)
			enemy.global_position = position
			enemy.setup(goal, target)
			enemy.enemy_killed_signal.connect(Callable(self,"_on_enemy_killed"))
			enemies.append(enemy)
			break
	spawn_timer.start(rng.randf_range(5 * spawnrate, 15 * spawnrate))


func _on_enemy_killed(enemy:Enemy):
	enemies.erase(enemy)
	enemy.queue_free()
