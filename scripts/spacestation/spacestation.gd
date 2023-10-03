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
const max_cargo = 7
const min_engines = 2
const max_engines = 3
const min_turrets = 2
const max_turrets = 3
const min_fuel = 2
const max_fuel = 6
const min_ammo = 2
const max_ammo = 6

func _ready():
	super()
	generate_components(0)

func generate_components(level:int):
	for x in component_map.size():
		for y in component_map[x].size():
			if component_map[x][y] != null:
				component_map[x][y].queue_free()
	var nr_cargo = 2
	var nr_engines = 1
	var nr_turrets = 1
	var nr_fuel = 1
	var nr_ammo = 1
	if level > 1:
		var usable_tile = min(nr_tiles, level + 6)
		var max = min(level + 2, max_cargo)
		nr_cargo = max
		var occupied = nr_cargo
		nr_engines = randi_range(0, 2)
		occupied += nr_engines
		nr_turrets = randi_range(0, 2)
		occupied += nr_turrets
		nr_fuel = randi_range(min_fuel, min(max_fuel, usable_tile - occupied))
		occupied += nr_fuel
		nr_ammo = usable_tile - occupied
	
	var i = 0
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
