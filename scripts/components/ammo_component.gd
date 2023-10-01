extends StructureComponent
class_name AmmoComponent

signal out_of_ammo(ammo)

@export var ammo_storage: int
@export var ammo_max_storage: int
@export var fuel_bar: TextureProgressBar

func _ready():
	super()
	type = Global.ComponentType.AMMO

func drain_ammo(amount:int):
	if amount >= ammo_storage:
		out_of_ammo.emit(self)
		if amount > ammo_storage:
			return ammo_storage
	ammo_storage -= amount
	print(ammo_storage)
	
	if fuel_bar != null:
		fuel_bar.value = float(ammo_storage)/float(ammo_max_storage)
		
	return amount
