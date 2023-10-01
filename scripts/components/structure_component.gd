extends Node2D
class_name StructureComponent

@export var type: Global.ComponentType
@export var health: HealthComponent
@export var weight: float
@export var shape: Array
@export var pos: Vector2
@export var sprite: Sprite2D
@export var neighbors: Array
@export var debug: bool = false
@onready var spaceship:SpaceShip = get_parent() if get_parent() is SpaceShip else null

func _ready():
	health.health_depleted.connect(Callable(self, "on_death"))

func place(new_position:Vector2):
	var corrected_position = spaceship.try_place_component(self, new_position)
	if corrected_position == null:
		return
	global_position = corrected_position

func get_neighbors():
	neighbors = spaceship.get_neighbors(self)

func on_death():
	print(name+": DIED of type " + Global.ComponentType.keys()[type])
