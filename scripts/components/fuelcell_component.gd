extends StructureComponent
class_name FuelCellComponent

signal out_of_fuel(cell)

@export var fuel_storage: float
@export var fuel_max_storage: float

func drain_fuel(amount:float):
	if amount >= fuel_storage:
		out_of_fuel.emit(self)
		if amount > fuel_storage:
			return fuel_storage
	fuel_storage -= amount
	return amount
