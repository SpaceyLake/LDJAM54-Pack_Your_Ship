class_name ShipTile

enum tile_type {NORMAL, ENGINE, WEAPON, UNI}

var type:tile_type
var position:Vector2
var texture:Texture2D = Texture2D.new()

func _init(type:String, position:Vector2):
#	print(position)
	if type.strip_escapes().to_lower() == "uni":
		self.type = tile_type.UNI
		self.texture.load
	elif type.strip_escapes().to_lower() == "engine":
		self.type = tile_type.ENGINE
	elif type.strip_escapes().to_lower() == "weapon":
		self.type = tile_type.WEAPON
	else:
		self.type = tile_type.NORMAL
	self.texture = load("res://assets/Tiles_Placeholder.png")
	self.position = position*2 - self.texture.get_size()/2;
