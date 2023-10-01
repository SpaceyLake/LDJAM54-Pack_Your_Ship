class_name ShipTile

var type:Global.ComponentType
var position:Vector2
var hex_position:Vector2
var texture:Texture2D = Texture2D.new()

func _init(component_type:Global.ComponentType, new_position:Vector2, new_hex_position:Vector2):
	self.type = component_type
	if self.type == Global.ComponentType.ENGINE:
		self.texture = load("res://assets/tiles/tile_engine.png")
	elif self.type == Global.ComponentType.WEAPON:
		self.texture = load("res://assets/tiles/tile_weapon.png")
	else:
		self.texture = load("res://assets/tiles/tile_normal.png")
	self.hex_position = new_hex_position
	self.position = new_position*2 - self.texture.get_size()/2;
