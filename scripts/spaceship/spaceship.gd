@tool
extends Node2D
class_name SpaceShip

signal recalculate_speed

@export var size:int = 32
@export_multiline var tiles_text:String = ""

var structures : Array
var speed : int
var tiles : Array
var ship_tiles : Array
var occupied_tiles : Array
var mapping_offset : Vector2
var mapping_max : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	var tile_strings = tiles_text.rsplit("\n", false)
	for tile_string in tile_strings:
		tile_string = tile_string.rstrip(")")
		var tile_split = tile_string.rsplit("(")
		var tile_position : Vector2 = str_to_var("Vector2(" + tile_split[1] + ")")
		var type:Global.ComponentType
		if tile_split[0].strip_escapes().to_lower() == "uni":
			type = Global.ComponentType.NONE
		elif tile_split[0].strip_escapes().to_lower() == "engine":
			type = Global.ComponentType.ENGINE
		elif tile_split[0].strip_escapes().to_lower() == "weapon":
			type = Global.ComponentType.WEAPON
		else:
			type = Global.ComponentType.NONE
		if tile_position.x < mapping_offset.x:
			mapping_offset.x = tile_position.x
		if tile_position.y < mapping_offset.y:
			mapping_offset.y = tile_position.y
		if tile_position.x > mapping_max.x:
			mapping_max.x = tile_position.x
		if tile_position.y > mapping_max.y:
			mapping_max.y = tile_position.y
		tiles.append(ShipTile.new(type, hex_to_pixel(tile_position) - global_position, tile_position))
	mapping_max += Vector2.ONE
	for x in mapping_max.x - mapping_offset.x:
		ship_tiles.append([])
		occupied_tiles.append([])
		for y in mapping_max.y - mapping_offset.y:
			ship_tiles[x].append(null)
			occupied_tiles[x].append(false)
	for tile in tiles:
		var tile_with_offset = tile.hex_position - mapping_offset
		ship_tiles[tile_with_offset.x][tile_with_offset.y] = tile.type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		crosses_ship(Vector2.ONE * 300, get_global_mouse_position())
		tiles = []
		ship_tiles = []
		_ready()
		queue_redraw()

func on_ship(point:Vector2):
	var hex_point = pixel_to_hex(point) - mapping_offset
	if hex_point.x >= ship_tiles.size() or hex_point.y >= ship_tiles[0].size() or hex_point.x < 0 or hex_point.y < 0:
		return false
	if ship_tiles[hex_point.x][hex_point.y] != null:
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

func place_component(component:StructureComponent, new_component_position:Vector2):
	var hex_position:Vector2 = pixel_to_hex(new_component_position)
	var hex_position_with_offset = hex_position - mapping_offset
	if hex_position_with_offset.x >= ship_tiles.size() or hex_position_with_offset.y >= ship_tiles[0].size():
		return null
	if occupied_tiles[hex_position_with_offset.x][hex_position_with_offset.y] == true:
		return null
	if component.type != ship_tiles[hex_position_with_offset.x][hex_position_with_offset.y]:
		if component.type == Global.ComponentType.WEAPON or component.type == Global.ComponentType.ENGINE:
			return null
	var current_hex_position_with_offset = pixel_to_hex(component.global_position) - mapping_offset
	if current_hex_position_with_offset.x < occupied_tiles.size() and current_hex_position_with_offset.y < occupied_tiles[0].size() and current_hex_position_with_offset.x >= 0 and current_hex_position_with_offset.y >= 0:
		occupied_tiles[current_hex_position_with_offset.x][current_hex_position_with_offset.y] = false
	return hex_to_pixel(hex_position)

func calculate_speed():
	var weight = 0
	var force = 0
	for structure in structures:
		weight += structure.weight()
		if structure is EngineComponent:
			force += structure.force()
	return force / weight

func hex_corners(hex:Vector2):
	var hex_position = hex_to_pixel(hex)
	var corners:Array
	var r = size*sqrt(3)/2
	var angles:Array = [-30, -90, 210, 150, 90, 30]

	for angle_deg in angles:
		var angle_rad = deg_to_rad(angle_deg)
		var corner = hex_position + Vector2(cos(angle_rad), sin(angle_rad)) * size
		corners.append(corner.round())
	return corners

func hex_to_pixel(hex:Vector2):
	var x = round(size * (1.75 * hex.x + 0.875 * hex.y))
	var y = round(size * 1.5625 * hex.y)
	return Vector2(x, y) + global_position

func pixel_to_hex(point:Vector2):
	point = to_local(point)
	var x = (sqrt(3)/3 * point.x - 1./3 * point.y) / size
	var y = (2./3 * point.y) / size
	return axial_round(Vector2(x,y))

func axial_round(hex:Vector2):
	return cube_to_axial(cube_round(axial_to_cube(hex)))

func cube_round(frac:Vector3):
	var x = round(frac.x)
	var y = round(frac.y)
	var z = round(frac.z)

	var x_diff = abs(x - frac.x)
	var y_diff = abs(y - frac.y)
	var z_diff = abs(z - frac.z)

	if x_diff > y_diff and x_diff > z_diff:
		x = -y-z
	elif y_diff > z_diff:
		y = -x-z
	else:
		z = -x-y

	return Vector3(x, y, z)

func cube_to_axial(cube:Vector3):
	var x = cube.x
	var y = cube.y
	return Vector2(x, y)

func axial_to_cube(hex:Vector2):
	var x = hex.x
	var y = hex.y
	var z = -x-y
	return Vector3(x, y, z)


func _on_recalculate_speed():
	speed = calculate_speed()

func _draw():
	for tile in tiles:
		draw_set_transform(Vector2.ZERO, 0, Vector2(0.5, 0.5))
		draw_texture(tile.texture, tile.position)

