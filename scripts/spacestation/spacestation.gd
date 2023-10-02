@tool
extends HexStructure
class_name Spacestation

@onready var standard_ammo = preload("res://scenes/components/ammo/standard_ammo.tscn")
@onready var standard_cargo = preload("res://scenes/components/cargo/standard_cargo.tscn")
@onready var standard_engine = preload("res://scenes/components/engine/standard_engine.tscn")
@onready var standard_fuelcell = preload("res://scenes/components/fuelcells/standard_fuelcell.tscn")
@onready var laser = preload("res://scenes/components/weapons/laser.tscn")
@onready var components:Array = [standard_ammo, standard_cargo, standard_engine, standard_fuelcell, laser]
@export var spaceship:SpaceShip

func _ready():
	super()
	generate_components()

func generate_components():
	for x in structure_map.size():
		for y in structure_map[x].size():
			if structure_map[x][y] != null and fmod(x, 2) == 0:
				var temp = components.pick_random().instantiate()
				temp.set_process(false)
				component_map[x][y] = temp
				add_child(temp)
				temp.global_position = hex_to_pixel(Vector2(x+mapping_offset.x,y+mapping_offset.y))

func _on_child_entered_tree(node):
	if node is StructureComponent:
		node.deactivate()
