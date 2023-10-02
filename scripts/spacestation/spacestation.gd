extends HexStructure
class_name Spacestation

@onready var standard_ammo = preload("res://scenes/components/ammo/standard_ammo.tscn")
@onready var standard_cargo = preload("res://scenes/components/cargo/standard_cargo.tscn")
@onready var standard_engine = preload("res://scenes/components/engine/standard_engine.tscn")
@onready var standard_fuelcell = preload("res://scenes/components/fuelcells/standard_fuelcell.tscn")
@onready var laser = preload("res://scenes/components/weapons/laser.tscn")
@onready var components:Array = [standard_ammo, standard_cargo, standard_engine, standard_fuelcell, laser]
@export var spaceship:SpaceShip
const nr_tiles = 19
const nr_cargo = 7
const min_engines = 2
const max_engines = 3
const min_turrets = 2
const max_turrets = 3
const min_fuel = 2
const max_fuel = 6
const min_ammo = 2
const max_ammo = 6
const free_slots = 2

func _ready():
	super()
	generate_components()

func generate_components():
	for x in component_map.size():
		for y in component_map[x].size():
			if component_map[x][y] != null:
				component_map[x][y].queue_free()
	var i = 0
	var occupied = nr_cargo - free_slots
	var nr_engines = randi_range(min_engines, min(max_engines, nr_tiles - occupied))
	var nr_turrets = randi_range(min_turrets, min(max_turrets, nr_tiles - occupied))
	var nr_fuel = randi_range(min_fuel, min(max_fuel, nr_tiles - occupied))
	var nr_ammo = randi_range(min_ammo, max(max_ammo, nr_tiles - occupied))
	for x in structure_map.size():
		for y in structure_map[x].size():
			if structure_map[x][y] != null:
				var temp = null
				if i < nr_cargo:
					temp = components[1].instantiate()
				elif i < nr_cargo + nr_engines:
					temp = components[2].instantiate()
				elif i < nr_cargo + nr_engines + nr_turrets:
					temp = components[4].instantiate()
				elif i < nr_cargo + nr_engines + nr_turrets + nr_fuel:
					temp = components[3].instantiate()
				elif i < nr_cargo + nr_engines + nr_turrets + nr_fuel + nr_ammo:
					temp = components[0].instantiate()
				else:
					return
				temp.deactivate()
				component_map[x][y] = temp
				add_child(temp)
				temp.global_position = hex_to_pixel(Vector2(x+mapping_offset.x,y+mapping_offset.y))
				i += 1

func _on_child_entered_tree(node):
	if node is StructureComponent:
		node.deactivate()
