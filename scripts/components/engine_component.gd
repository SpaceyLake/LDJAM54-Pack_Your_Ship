extends StructureComponent
class_name EngineComponent

signal force_change(old_force, new_force)

@export var fuel_drain: float
@export var fuel_storage: float
@export var fuel_max_storage: float
@export var force: float
@export var force_max: float
@export var fuel_bar: TextureProgressBar
var fuelcells: Array

func _ready():
	super()
	type = ComponentType.ENGINE
	get_fuelcells()
	
	for fuelcell in fuelcells:
		fuelcell.out_of_fuel.connect(Callable(self, "fuelcell_out_of_fuel"))

func _process(delta):
	if fuel_storage < fuel_max_storage and fuelcells.size() > 0:
		fuelcells.sort_custom(func(a, b): return a.fuel_storage < b.fuel_storage)
		fuel_storage += fuelcells[0].drain_fuel(fuel_max_storage-fuel_storage)
	
	if fuelcells.size():
		fuelcells.sort_custom(func(a, b): return a.fuel_storage < b.fuel_storage)
		fuelcells[0].drain_fuel(fuel_drain * delta)
	elif fuel_storage > 0:
		fuel_storage -= fuel_drain * delta
	else:
		fuel_storage = 0
		var old = force
		force = 0
		force_change.emit(old, force)
	if fuel_bar != null:
		fuel_bar.value = fuel_storage/fuel_max_storage

func fuelcell_out_of_fuel(fuelcell:FuelCellComponent):
	fuelcells.remove_at(fuelcells.find(fuelcell))
	fuelcell.queue_free()

func get_fuelcells():
	for neighbor in neighbors:
		if neighbor.type == ComponentType.FUELCELL:
			fuelcells.append(neighbor)

func on_death():
	super()
	fuel_storage = 0
