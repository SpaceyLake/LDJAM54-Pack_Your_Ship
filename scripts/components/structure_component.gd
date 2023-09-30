extends Node2D
class_name StructureComponent

enum ComponentType {
	NONE,
	ENGINE,
	FUELCELL,
	WEAPON,
	AMMO,
	CARGO
}

@export var type: ComponentType
@export var health: HealthComponent
@export var weight: float
@export var shape: Array
@export var pos: Vector2
@export var sprite: Sprite2D
@export var neighbors: Array
@export var debug: bool = false
@onready var spaceship:SpaceShip = get_parent().get_node("Spaceship")

func _ready():
	health.health_depleted.connect(Callable(self, "on_death"))

func place(new_position:Vector2):
	var corrected_position = spaceship.place_component(new_position)
	if corrected_position == null:
		return
	global_position = corrected_position

func on_death():
	print(name+":DIED")
