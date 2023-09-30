extends Node2D
class_name StructureComponent

enum ComponentType {
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

func _ready():
	health.health_depleted.connect(Callable(self, "on_death"))
	health.health_depleted.connect(Callable(self, "on_death"))


func _process(delta):
	pass


func step(delta):
	pass


func on_death():
	if debug:
		print("DEAD")
