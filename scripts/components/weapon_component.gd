extends StructureComponent
class_name WeaponComponent

@export var distance: float
@export var projectile: Projectile
@export var ammo_storage: int
@export var ammo_max_storage: int
@export var target: Node2D
@export var turret_head: Sprite2D
@export var barrel_distance: float
@export var barrel_rotation_speed: float
var ammo_cells: Array

func _ready():
	super()
	type = ComponentType.WEAPON
	get_ammo()
	
	for ammo_cell in ammo_cells:
		ammo_cell.out_of_ammo.connect(Callable(self, "ammo_cell_out_of_fuel"))

func rotate_towards_mouse(delta):
	#if target != null:
	var target_angle = position.angle_to_point(get_global_mouse_position())
	var _diff = target_angle - turret_head.global_rotation
	_diff = wrap(_diff, -PI, PI)
	turret_head.global_rotation += sign(_diff) * min(barrel_rotation_speed * delta, abs(_diff))

func rotate_towards_target(delta):
	if target != null:
		var target_angle = turret_head.position.angle_to_point(get_global_mouse_position())
		var _diff = target_angle - turret_head.global_rotation
		_diff = wrap(_diff, -PI, PI)
		turret_head.global_rotation += sign(_diff) * min(barrel_rotation_speed * delta, abs(_diff))

func ammo_cell_out_of_fuel(ammo_cell:AmmoComponent):
	ammo_cells.remove_at(ammo_cells.find(ammo_cell))

func get_ammo():
	for neighbor in neighbors:
		if neighbor.type == ComponentType.AMMO:
			ammo_cells.append(neighbor)

func fire():
	pass

func debug_distance(event:InputEvent):
	if debug:
		if event is InputEventMouseMotion:
			print("Distance:", position - get_global_mouse_position())

func debug_target():
	draw_line(position, target.position, Color.MAGENTA, 2.0)
