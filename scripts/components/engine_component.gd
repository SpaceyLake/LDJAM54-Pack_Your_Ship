extends StructureComponent
class_name EngineComponent

signal force_change(old_force, new_force)

@export var fuel_drain: float
@export var fuel_storage: float
@export var fuel_max_storage: float
@export var force: float
@export var force_max: float
var fuelcells: Array

func _ready():
	super()
	get_fuelcells()
	
	for fuelcell in fuelcells:
		fuelcell.out_of_fuel.connect(Callable(self, "fuelcell_out_of_fuel"))

func step(delta):
	if fuel_storage > 0:
		if fuelcells.size():
			fuelcells.sort_custom(func(a, b): return a.fuel_storage < b.fuel_storage)
			fuelcells[0].drain_fuel(fuel_drain * delta)
		else:
			fuel_storage -= fuel_drain * delta
	else:
		fuel_storage = 0
		var old = force
		force = 0
		force_change.emit(old, force)

func fuelcell_out_of_fuel(fuelcell:FuelCellComponent):
	fuelcells.remove_at(fuelcells.find(fuelcell))

func get_fuelcells():
	for neighbor in neighbors:
		if neighbor.type == ComponentType.FUELCELL:
			fuelcells.append(neighbor)
