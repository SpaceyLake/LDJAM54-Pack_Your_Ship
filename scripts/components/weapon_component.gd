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
@export var ammo_bar: TextureProgressBar
@export var out_of_ammo: Sprite2D
@export var ray: RayCast2D

var fire:bool = false
var ammo_cells: Array
var enemies: Array

func _ready():
	super()
	deactivate()
	type = Global.ComponentType.WEAPON
	targeting.not_ready_to_fire.connect(Callable(self, "aiming"))
	targeting.ready_to_fire.connect(Callable(self, "aimed"))
	
	for ammo_cell in ammo_cells:
		ammo_cell.out_of_ammo.connect(Callable(self, "ammo_cell_out_of_fuel"))

func _process(delta):
	if ammo_cells.is_empty():
		get_neighbors()
		get_ammo()
	if target != null:
		targeting.target = target
		targeting.rotate_towards_target(delta)
	else:
		select_target()
		if target != null:
			targeting.target = target
			targeting.rotate_towards_target(delta)
	fire_gun()

func deactivate():
	set_process(false)

func activate():
	set_process(true)

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

func get_neighbors():
	super()
	ammo_cells.clear()
	get_ammo()

func get_ammo():
	for neighbor in neighbors:
		if neighbor != null and neighbor.type == Global.ComponentType.AMMO:
			neighbor.out_of_ammo.connect(Callable(self,"ammo_cell_out_of_fuel"))
			ammo_cells.append(neighbor)

func fire_gun():
	if ammo_storage < ammo_max_storage and ammo_cells.size() > 0:
		ammo_cells.sort_custom(func(a, b): return a.ammo_storage < b.ammo_storage)
		ammo_storage += ammo_cells[0].drain_ammo(ammo_max_storage-ammo_storage)
	
	if fire and not animation_player.is_playing() and not ray.is_colliding() and ammo_storage > 0:
		var proj = projectile.instantiate()
		add_child(proj)
		proj.global_position = turret_muzzel.global_position
		proj.target = Vector2(1,0).rotated(turret.global_rotation) #target.global_position - global_position
		animation_player.play("fire")
		
		if ammo_cells.size():
			ammo_cells.sort_custom(func(a, b): return a.ammo_storage < b.ammo_storage)
			ammo_cells[0].drain_ammo(1)
		elif ammo_storage > 0:
			ammo_storage -= 1
		
		if ammo_bar != null:
			ammo_bar.value = float(ammo_storage)/float(ammo_max_storage)
	
	if fire and ray.is_colliding():
		target = enemies.pick_random()
	
	if ammo_storage < 1: 
		out_of_ammo.visible = true
	else: 
		out_of_ammo.visible = false

func select_target():
	enemies.clear()
	if not spaceship is SpaceShip:
		return
	for enemy in spaceship.enemies_node.enemies:
		enemies.append(enemy)

	if enemies.size():
		enemies.sort_custom(func(a,b): return targeting.get_rotation_needed(a) < targeting.get_rotation_needed(b))
		target = enemies[0]

func aiming():
	fire = false

func aimed():
	fire = true

func debug_distance(event:InputEvent):
	if debug:
		if event is InputEventMouseMotion:
			print("Distance:", position - get_global_mouse_position())

func debug_target():
	draw_line(position, target.position, Color.MAGENTA, 2.0)
