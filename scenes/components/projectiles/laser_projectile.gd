extends Projectile

func _ready():
	super()

func _process(delta):
	position += target * delta
