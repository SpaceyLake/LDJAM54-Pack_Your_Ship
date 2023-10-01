@tool
extends HexStructure
class_name SpaceShip

signal recalculate_speed

@export var enemies_node:Node

@onready var standard_ammo = preload("res://scenes/components/ammo/standard_ammo.tscn")
@onready var standard_cargo = preload("res://scenes/components/cargo/standard_cargo.tscn")
@onready var standard_engine = preload("res://scenes/components/engine/standard_engine.tscn")
@onready var standard_fuelcell = preload("res://scenes/components/fuelcells/standard_fuelcell.tscn")
@onready var laser = preload("res://scenes/components/weapons/laser.tscn")

var structures : Array
var speed : int
var components: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	for x in structure_map.size():
		var y_size = structure_map[x].size()
		for y in y_size:
			match structure_map[x][y]:
				Global.ComponentType.AMMO: 
					var temp = standard_ammo.instantiate()
					component_map[x][y] = temp
					add_child(temp)
					temp.global_position = hex_to_pixel(Vector2(x+mapping_offset.x,y+mapping_offset.y))
				Global.ComponentType.CARGO: 
					var temp = standard_ammo.instantiate()
					component_map[x][y] = temp
					add_child(temp)
					temp.global_position = hex_to_pixel(Vector2(x+mapping_offset.x,y+mapping_offset.y))
				Global.ComponentType.ENGINE: 
					var temp = standard_engine.instantiate()
					component_map[x][y] = temp
					add_child(temp)
					temp.global_position = hex_to_pixel(Vector2(x+mapping_offset.x,y+mapping_offset.y))
				Global.ComponentType.FUELCELL: 
					var temp = standard_fuelcell.instantiate()
					component_map[x][y] = temp
					add_child(temp)
					temp.global_position = hex_to_pixel(Vector2(x+mapping_offset.x,y+mapping_offset.y))
				Global.ComponentType.WEAPON: 
					var temp = laser.instantiate()
					component_map[x][y] = temp
					add_child(temp)
					temp.global_position = hex_to_pixel(Vector2(x+mapping_offset.x,y+mapping_offset.y))
					return

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Input.is_action_just_pressed("ui_accept"):
#		crosses_ship(Vector2.ONE * 300, get_global_mouse_position())
#		tiles = []
#		ship_tiles = []
#		occupied_tiles = []
#		_ready()
#		queue_redraw()

func _input(event):
	if event.is_action_pressed("interact"):
		pass # Grab component
	if event.is_action_released("interact"):
		pass # Place component

func on_ship(point:Vector2):
	var hex_point = pixel_to_hex(point) - mapping_offset
	if hex_point.x >= structure_map.size() or hex_point.y >= structure_map[0].size() or hex_point.x < 0 or hex_point.y < 0:
		return false
	if structure_map[hex_point.x][hex_point.y] != null:
		return true
	return false

func crosses_ship(start_point:Vector2, goal_point:Vector2):
	for tile in tiles:
		var hex_position = hex_to_pixel(tile.hex_position)
		var crossing_unit:Vector2 = (goal_point - start_point).normalized()
		var ship_reference:Vector2 = hex_position + Vector2(crossing_unit.y, -crossing_unit.x) * (hex_position.y / crossing_unit.x)
		var tile_point = hex_position + (hex_position - ship_reference).normalized() * size
		if ccw(start_point, goal_point, tile_point) != ccw(goal_point, ship_reference, tile_point) and ccw(start_point, goal_point, ship_reference) != ccw(start_point, goal_point, tile_point):
			return true
	return false

func ccw(vec_a:Vector2, vec_b:Vector2, vec_c:Vector2):
	return (vec_c.y - vec_a.y) * (vec_b.x - vec_a.x) > (vec_b.y - vec_a.y) * (vec_c.x - vec_a.x)

func try_place_component(component:StructureComponent, new_component_position:Vector2):
	var hex_position:Vector2 = pixel_to_hex(new_component_position)
	var hex_index = hex_position - mapping_offset
	if not tile_free(hex_index) or not match_component_type(component.type, hex_index):
		return null
	return place_component(component, hex_position, hex_index)

func calculate_speed():
	var weight = 0
	var force = 0
	for structure in structures:
		weight += structure.weight()
		if structure is EngineComponent:
			force += structure.force()
	return force / weight

func _on_recalculate_speed():
	speed = calculate_speed()

