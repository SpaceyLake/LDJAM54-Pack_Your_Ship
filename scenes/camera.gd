extends Node2D

@export var shake_random_strength: float = 30.0
@export var shake_decay_rate: float = 5.0
@export var shake_noise_speed: float = 30.0
@export var shake_noise_strength: float = 60.0

@onready var rand = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()
@onready var camera = $Camera2D

var noise_i: float = 0.0
var shake_strength: float = 0.0

func _ready():
	Global.camera = self
	
	noise.seed = rand.randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.5

func _exit():
	Global.camera = null

func apply_shake(strength: float = shake_noise_strength) -> void:
	shake_strength = strength

func _input(event):
	if event.is_action_pressed("ui_accept"):
		apply_shake()

func _process(delta: float) -> void:
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	camera.offset = get_noise_offset(delta)

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * shake_noise_speed
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)
