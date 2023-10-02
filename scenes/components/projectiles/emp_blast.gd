extends Projectile


func _ready():
	sprite.modulate = Color(0.4,0.6,0.9,0.6)
	timer.start(2)
