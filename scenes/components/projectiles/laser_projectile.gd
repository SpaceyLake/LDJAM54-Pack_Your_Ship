extends Projectile

func _ready():
	setup()

func _process(delta):
	position += target * delta
