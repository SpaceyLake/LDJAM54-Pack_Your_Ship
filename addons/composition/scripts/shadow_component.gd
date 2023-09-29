extends Node2D
class_name ShadowComponent2D

@export var radius: float = 1.0
@export var width: float = 0.0
@export var height: float = 0.0
@export var color: Color = Color(0.1, 0.1, 0.1, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	update()

func update():
	queue_redraw()

func set_color(New_Color: Color):
	color = New_Color
	update()

func set_width(Width: float):
	width = Width
	update()

func set_height(Height: float):
	height = Height
	update()

func set_radius(Radius: float):
	radius = Radius
	update()

func _draw():
	if width > 0.0:
		draw_circle(Vector2(self.position.x + width, self.position.y), radius, color)
		draw_rect(Rect2(self.position.x - width, self.position.y - radius, width*2, radius*2), color, true)
		draw_circle(Vector2(self.position.x - width, self.position.y), radius, color)
	if height > 0.0:
		draw_circle(Vector2(self.position.x, self.position.y + height), radius, color)
		draw_rect(Rect2(self.position.x - radius, self.position.y - height, radius*2, height*2), color, true)
		draw_circle(Vector2(self.position.x, self.position.y - height), radius, color)
	if width <= 0.0 and height <= 0.0:
		draw_circle(self.position, radius, color)
