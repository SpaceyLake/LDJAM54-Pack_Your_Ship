extends StructureComponent
class_name CargoComponent

@export var value: float
@export var quest_item: bool
@export var destination_distance: int
@export var destination_name: String

func _ready():
	super()
	type = ComponentType.CARGO
