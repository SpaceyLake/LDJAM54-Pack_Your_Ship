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

func get_closest_component_position(point:Vector2):
	var hex_point = pixel_to_hex(point)
	var hex_index = hex_point - mapping_offset
	var shortest_distance = -1
	var closest_index = null
	for x in component_map.size():
		for y in component_map[0].size():
			if component_map[x][y] != null:
				var distance = hex_index.distance_squared_to(Vector2(x,y))
				if shortest_distance == -1 or distance < shortest_distance:
					shortest_distance = distance
					closest_index = Vector2(x,y)
	if closest_index == null:
		return global_position
	return hex_to_pixel(closest_index + mapping_offset)

func _on_recalculate_speed():
	speed = calculate_speed()

func _on_child_entered_tree(node):
	if node is StructureComponent:
		node.activate()
