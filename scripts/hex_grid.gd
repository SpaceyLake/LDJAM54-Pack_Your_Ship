@tool
extends Node2D

@export var size:int = 32
@export_multiline var tiles_text:String = ""

var structure_tiles : Array
var occupied_tiles : Array
var mapping_offset : Vector2
var mapping_max : Vector2
var tiles : Array

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
		structure_tiles.append([])
		occupied_tiles.append([])
		for y in mapping_max.y - mapping_offset.y:
			structure_tiles[x].append(null)
			occupied_tiles[x].append(null)
	for tile in tiles:
		var tile_with_offset = tile.hex_position - mapping_offset
		structure_tiles[tile_with_offset.x][tile_with_offset.y] = tile.type


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

func _draw():
	for tile in tiles:
		draw_set_transform(Vector2.ZERO, 0, Vector2(0.5, 0.5))
		draw_texture(tile.texture, tile.position)
