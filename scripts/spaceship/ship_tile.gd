class_name ShipTile

var type:Global.tile_type
var position:Vector2
var texture:Texture2D = Texture2D.new()

func _init(type:Global.tile_type, position:Vector2):
	self.type = type
	self.texture = load("res://assets/Tiles_Placeholder.png")
	self.position = position*2 - self.texture.get_size()/2;
