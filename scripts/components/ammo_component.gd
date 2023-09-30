extends StructureComponent
class_name AmmoComponent

signal out_of_ammo(ammo)

@export var ammo_storage: int
@export var ammo_max_storage: int

func drain_ammo(amount:int):
	if amount >= ammo_storage:
		out_of_ammo.emit(self)
		if amount > ammo_storage:
			return ammo_storage
	ammo_storage -= amount
	return amount
