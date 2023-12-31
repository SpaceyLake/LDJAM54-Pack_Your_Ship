extends Node2D
class_name HexStructure

@export var size:int = 32
@export_multiline var tiles_text:String = ""

var structure_map : Array
var component_map : Array
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
		elif tile_split[0].strip_escapes().to_lower() == "ammo":
			type = Global.ComponentType.AMMO
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
		tiles.append(ShipTile.new(type, hex_to_pixel(tile_position), tile_position, global_position))
	mapping_max += Vector2.ONE
	for x in mapping_max.x - mapping_offset.x:
		structure_map.append([])
		component_map.append([])
		for y in mapping_max.y - mapping_offset.y:
			structure_map[x].append(null)
			component_map[x].append(null)
	for tile in tiles:
		var tile_with_offset = tile.hex_position - mapping_offset
		structure_map[tile_with_offset.x][tile_with_offset.y] = tile.type

func try_place_component(component:StructureComponent, new_component_position:Vector2):
	var hex_position:Vector2 = pixel_to_hex(new_component_position)
	var hex_index = hex_position - mapping_offset
	if not on_structure(hex_index):
		return null
	return place_component(component, hex_position, hex_index)

func on_structure(hex_index:Vector2):
	if hex_index.x < 0 or hex_index.x >= component_map.size():
		return false
	if hex_index.y < 0 or hex_index.y >= component_map[0].size():
		return false
	if structure_map[hex_index.x][hex_index.y] == null:
		return false
	return true

func match_component_type(type:Global.ComponentType, hex_index:Vector2):
	if type != structure_map[hex_index.x][hex_index.y]:
		return false
	return true

func place_component(component:StructureComponent, hex_position:Vector2, hex_index:Vector2):
	var component_global_position = component.global_position
	if not component.get_parent() == self:
		component.get_parent().remove_component(component)
		add_child(component)
	else:
		var current_hex_position:Vector2 = pixel_to_hex(component.global_position)
		var current_hex_index = current_hex_position - mapping_offset
		component_map[current_hex_index.x][current_hex_index.y] = null
		
	if component_map[hex_index.x][hex_index.y] != null:
		component_map[hex_index.x][hex_index.y].place(component_global_position)
		
	component_map[hex_index.x][hex_index.y] = component
	
	return hex_to_pixel(hex_position)

func remove_component(component:StructureComponent):
	var hex_position:Vector2 = pixel_to_hex(component.global_position)
	var hex_index = hex_position - mapping_offset
	component_map[hex_index.x][hex_index.y] = null
	remove_child(component)

func get_neighbors(component:StructureComponent):
	var hex_position = pixel_to_hex(component.global_position)
	var hex_index = hex_position - mapping_offset
	var neighbors_offset:Array = [Vector2(-1, 0), Vector2(-1, 1), Vector2(0, -1), Vector2(0, 1), Vector2(1, -1), Vector2(1, 0)]
	var neighbors:Array = []
	for offset in neighbors_offset:
		var neighbor_index = hex_index + offset
		if neighbor_index.x >= 0 and neighbor_index.x < component_map.size():
			if neighbor_index.y >= 0 and neighbor_index.y < component_map[0].size():
				if component_map[neighbor_index.x][neighbor_index.y] != null:
					neighbors.append(component_map[neighbor_index.x][neighbor_index.y])
	return neighbors

func hex_corners(hex:Vector2):
	var hex_position = hex_to_pixel(hex)
	var corners:Array = []
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
		draw_texture(tile.texture, tile.draw_position)
