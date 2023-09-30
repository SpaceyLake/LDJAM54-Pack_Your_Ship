@tool
extends Node2D
class_name SpaceShip

signal recalculate_speed

@export var size:int = 32
@export_multiline var tiles_text:String = ""

var structures : Array
var speed : int
var tiles : Array
var occupied_tiles : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 10:
		occupied_tiles.append([])
		for j in 10:
			occupied_tiles[i].append(null)
	var tile_strings = tiles_text.rsplit("\n", false)
	for tile_string in tile_strings:
		tile_string = tile_string.rstrip(")")
		var tile_split = tile_string.rsplit("(")
		var tile_position : Vector2 = str_to_var("Vector2(" + tile_split[1] + ")")
		var type:Global.tile_type
		if tile_split[0].strip_escapes().to_lower() == "uni":
			type = Global.tile_type.UNI
			self.texture.load
		elif tile_split[0].strip_escapes().to_lower() == "engine":
			type = Global.tile_type.ENGINE
		elif tile_split[0].strip_escapes().to_lower() == "weapon":
			type = Global.tile_type.WEAPON
		else:
			type = Global.tile_type.NORMAL
		occupied_tiles[tile_position.x][tile_position.y]
		tiles.append(ShipTile.new(type, hex_to_pixel(tile_position)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		tiles = []
		occupied_tiles = []
		_ready()
		queue_redraw()

func place_component(component_position):
	var hex_position:Vector2 = pixel_to_hex(component_position)
	
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
	return Vector2(x, y)

func pixel_to_hex(point:Vector2):
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

