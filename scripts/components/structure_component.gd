extends Node2D
class_name StructureComponent

@export var type: Global.ComponentType
@export var hurt_box: HurtboxComponent2D
@export var health: HealthComponent
@export var weight: float
@export var shape: Array
@export var pos: Vector2
@export var sprite: Sprite2D
@export var neighbors: Array
@export var debug: bool = false
@export var death_audio:AudioStreamPlayer
@onready var spacestation = get_parent() if get_parent() is Spacestation else null
@onready var spaceship = null if spacestation == null else spacestation.spaceship

func _ready():
	health.health_depleted.connect(on_death)
	hurt_box.area_entered.connect(on_hit)

func place(new_position:Vector2):
	var corrected_position = spaceship.try_place_component(self, new_position)
	if corrected_position == null:
		corrected_position = spacestation.try_place_component(self, new_position)
	if corrected_position == null:
		return
	global_position = corrected_position
	spaceship.update_neighbors()

func get_neighbors():
	neighbors.clear()
	if get_parent() == spaceship:
		neighbors = spaceship.get_neighbors(self)
	else:
		neighbors.clear()

func on_hit(node:Node2D):
	if node is AttackComponent2D:
		Global.screen_shake(5)

func on_death():
	Global.screen_shake(40)
	death_audio.play(0)
	print(name+": DIED of type " + Global.ComponentType.keys()[type])

func activate():
	pass

func deactivate():
	pass
