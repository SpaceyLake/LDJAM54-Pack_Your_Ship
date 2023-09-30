extends StructureComponent
class_name WeaponComponent

@export var distance: float
@export var projectile: PackedScene
@export var ammo_storage: int
@export var ammo_max_storage: int
@export var target: Node2D
@export var targeting: TargetingComponent2D
@export var turret: Node2D
@export var turret_muzzel: Marker2D
@export var barrel_rotation_speed: float
@export var animation_player: AnimationPlayer
var ammo_cells: Array

func _ready():
	super()
	type = ComponentType.WEAPON
	get_ammo()
	
	for ammo_cell in ammo_cells:
		ammo_cell.out_of_ammo.connect(Callable(self, "ammo_cell_out_of_fuel"))

func _process(delta):
	if target != null:
		targeting.target = target
		targeting.rotate_towards_target(delta)

func rotate_towards_mouse(delta):
	#if target != null:
	var target_angle = position.angle_to_point(get_global_mouse_position())
	var _diff = target_angle - turret.global_rotation
	_diff = wrap(_diff, -PI, PI)
	turret.global_rotation += sign(_diff) * min(barrel_rotation_speed * delta, abs(_diff))

func rotate_towards_target(delta):
	if target != null:
		var target_angle = turret.position.angle_to_point(get_global_mouse_position())
		var _diff = target_angle - turret.global_rotation
		_diff = wrap(_diff, -PI, PI)
		turret.global_rotation += sign(_diff) * min(barrel_rotation_speed * delta, abs(_diff))

func ammo_cell_out_of_fuel(ammo_cell:AmmoComponent):
	ammo_cells.remove_at(ammo_cells.find(ammo_cell))
	ammo_cell.queue_free()

func get_ammo():
	for neighbor in neighbors:
		if neighbor.type == ComponentType.AMMO:
			ammo_cells.append(neighbor)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		fire()

func fire():
	if not animation_player.is_playing():
		var proj = projectile.instantiate()
		add_child(proj)
		proj.global_position = turret_muzzel.global_position
		proj.target = Vector2(1,0).rotated(turret.global_rotation) #target.global_position - global_position
		animation_player.play("fire")

func debug_distance(event:InputEvent):
	if debug:
		if event is InputEventMouseMotion:
			print("Distance:", position - get_global_mouse_position())

func debug_target():
	draw_line(position, target.position, Color.MAGENTA, 2.0)
