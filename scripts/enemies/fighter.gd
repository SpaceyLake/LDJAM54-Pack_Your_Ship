extends Enemy

@export var velocity = 350
@export var rotation_velocity = 10
@export var projectile: PackedScene
@onready var muzzle_l = $MuzzleL
@onready var muzzle_r = $MuzzleR
@onready var attackTimer = $AttackTimer
@onready var muzzles = [muzzle_l, muzzle_r]

var muzzle:int

func _ready():
	super()
	muzzle = randi_range(0, 1)

func _process(delta):
	if global_position != goal:
		global_rotation = (goal - global_position).angle()
		global_position = global_position.move_toward(goal, velocity*delta)
	elif fly:
		enemy_killed_signal.emit(self)
		remove()
	if target == null:
		target = spaceship.get_closest_component(goal)
		if target == null:
			attackTimer.stop()
			return
	if target.health.current_health <= 0:
		target = null
		attackTimer.stop()
		return
	if global_position == goal and global_rotation:
		global_rotation = move_toward(global_rotation, (target.global_position - global_position).angle(), rotation_velocity * delta)
	if global_position == goal and global_rotation == (target.global_position - global_position).angle() and attackTimer.is_stopped():
		attackTimer.start()

func _on_attack_timer_timeout():
	fire()

func on_death():
	attackTimer.stop()
	super()

func fire():
	var proj = projectile.instantiate()
	get_parent().add_child(proj)
	proj.global_position = muzzles[muzzle].global_position
	fire_audio.play(0)
	proj.target = muzzles[muzzle].global_position.direction_to(target.global_position)
	muzzle = int(fmod(muzzle + 1, 2))
