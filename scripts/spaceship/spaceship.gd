extends HexStructure
class_name SpaceShip

signal dead

@export var enemies_node:Node
@export var audio:AudioStreamPlayer

func _ready():
	super()
	if audio != null:
		audio.volume_db = Global.sound
	audio.play(0)

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
	var try = super(component, new_component_position)
	if try != null:
		var hex_position:Vector2 = pixel_to_hex(new_component_position)
		var hex_index = hex_position - mapping_offset
		if component.type == Global.ComponentType.ENGINE or component.type == Global.ComponentType.WEAPON:
			if match_component_type(component.type, hex_index):
				component.release_stanby()
			else:
				component.set_standby()
	return try

func get_weight() -> float:
	var weight = 100.0
	for x in component_map.size():
		for y in component_map[0].size():
			if component_map[x][y] != null:
				weight += component_map[x][y].weight
	return weight

func component_lost(component):
	if not alive(component):
		dead.emit()

func alive(component):
	var alive: int = 0
	for x in component_map.size():
		for y in component_map[0].size():
			if component_map[x][y] != null and component_map[x][y].type == Global.ComponentType.ENGINE and component_map[x][y] != component:
				if component_map[x][y].fuel_storage > 0:
					alive += 1
	print(alive)
	if alive>0:
		return true
	return false

func get_force():
	var force = 0.0
	for x in component_map.size():
		for y in component_map[0].size():
			if component_map[x][y] != null and component_map[x][y].type == Global.ComponentType.ENGINE:
				force += component_map[x][y].force
	return force

func get_speed() -> float:
	var speed = 0.0
	speed = get_force() / get_weight()
	return speed

func activate_components():
	for x in component_map.size():
		for y in component_map[0].size():
			if component_map[x][y] != null:
				component_map[x][y].activate()

func deactivate_components():
	for x in component_map.size():
		for y in component_map[0].size():
			if component_map[x][y] != null:
				component_map[x][y].deactivate()

func update_neighbors():
	for x in component_map.size():
		for y in component_map[0].size():
			if component_map[x][y] != null:
				component_map[x][y].get_neighbors()
				if not component_map[x][y].destroyed.is_connected(component_lost):
					component_map[x][y].destroyed.connect(component_lost)
				if component_map[x][y].type == Global.ComponentType.ENGINE:
					if not component_map[x][y].force_change.is_connected(component_lost):
						component_map[x][y].force_change.connect(component_lost)

func get_closest_component(point:Vector2):
	var hex_point = pixel_to_hex(point)
	var hex_index = hex_point - mapping_offset
	var shortest_distance = -1
	var closest_component = null
	for x in component_map.size():
		for y in component_map[0].size():
			if component_map[x][y] != null:
				if component_map[x][y].health.current_health > 0:
					var distance = hex_index.distance_squared_to(Vector2(x,y))
					if shortest_distance == -1 or distance < shortest_distance:
						shortest_distance = distance
						closest_component = component_map[x][y]
	return closest_component

func _on_child_entered_tree(node):
	if node is StructureComponent:
		#node.activate() not needed with current implementation since they are activated on departure
		pass

func has_engine():
	for x in component_map.size():
		for y in component_map[x].size():
			if component_map[x][y] != null and component_map[x][y].type == Global.ComponentType.ENGINE:
				return true
	return false

func deliver_cargo():
	var cargo = 0
	for x in component_map.size():
		for y in component_map[x].size():
			if component_map[x][y] != null and component_map[x][y].type == Global.ComponentType.CARGO:
				component_map[x][y].queue_free()
				component_map[x][y] = null
				cargo += 1
	return cargo
