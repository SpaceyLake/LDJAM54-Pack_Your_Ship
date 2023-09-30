extends StructureComponent
class_name FuelCellComponent

signal out_of_fuel(cell)

@export var fuel_storage: float
@export var fuel_max_storage: float
@export var fuel_bar: TextureProgressBar

func _ready():
	super()
	type = ComponentType.FUELCELL

func drain_fuel(amount:float):
	if amount >= fuel_storage:
		out_of_fuel.emit(self)
		if amount > fuel_storage:
			amount = fuel_storage
	fuel_storage -= amount
	
	if fuel_bar != null:
		fuel_bar.value = fuel_storage/fuel_max_storage
	
	return amount
