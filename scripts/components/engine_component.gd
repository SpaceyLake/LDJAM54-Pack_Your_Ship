extends StructureComponent
class_name EngineComponent

signal force_change

@export var fuel_drain: float
@export var fuel_storage: float
@export var fuel_max_storage: float
@export var force: float
@export var force_max: float
@export var fuel_bar: TextureProgressBar
@export var out_of_fuel: Sprite2D
@export var particles: GPUParticles2D
var fuelcells: Array

func _ready():
	super()
	deactivate()
	type = Global.ComponentType.ENGINE

func _process(delta):
	if fuelcells.is_empty():
		get_neighbors()
		get_fuelcells()
	
	if fuel_storage < fuel_max_storage and fuelcells.size() > 0:
		fuelcells.sort_custom(func(a, b): return a.fuel_storage < b.fuel_storage)
		fuel_storage += fuelcells[0].drain_fuel(fuel_max_storage-fuel_storage)
	get_neighbors()
	get_fuelcells()
	if fuelcells.size():
		force = force_max
		fuelcells.sort_custom(func(a, b): return a.fuel_storage < b.fuel_storage)
		fuelcells[0].drain_fuel(fuel_drain * delta)
	elif fuel_storage > 0:
		force = force_max
		fuel_storage -= fuel_drain * delta
	else:
		fuel_storage = 0
		force = 0
		force_change.emit(null)
	
	if fuel_bar != null:
		fuel_bar.value = fuel_storage/fuel_max_storage
	
	if particles != null:
		if force > 0:
			particles.emitting = true
			out_of_fuel.visible = false
		else:
			particles.emitting = false
			out_of_fuel.visible = true

func get_neighbors():
	super()
	fuelcells.clear()
	for fuelcell in fuelcells:
		fuelcell.out_of_fuel.disconnect(fuelcell_out_of_fuel)
	get_fuelcells()

func deactivate():
	if active:
		force = 0
		force_change.emit(null)
	particles.emitting = false
	super()

func activate():
	if super():
		particles.emitting = true
		if fuelcells.size() or fuel_storage > 0:
			force = force_max
			force_change.emit(null)

func fuelcell_out_of_fuel(fuelcell:FuelCellComponent):
	if fuelcells.size() > 0:
		fuelcells.remove_at(fuelcells.find(fuelcell))
		fuelcell.queue_free()

func get_fuelcells():
	for neighbor in neighbors:
		if neighbor != null and neighbor.type == Global.ComponentType.FUELCELL:
			if not neighbor.out_of_fuel.is_connected(fuelcell_out_of_fuel):
				neighbor.out_of_fuel.connect(fuelcell_out_of_fuel)
			fuelcells.append(neighbor)

func on_death():
	super()
	fuel_storage = 0
