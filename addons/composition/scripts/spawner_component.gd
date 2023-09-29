extends Node2D
class_name SpawnerComponent2D

@export var node: Node2D
@export var pos: Vector2 = Vector2(0,0)
@export var root: Node2D = self

func _ready():
	if node != null:
		spawn_node(node, pos, root)

func spawn_node(Spawn:Node2D, Position:Vector2 = Vector2(0,0), Root:Node2D = self):
	node = Spawn.duplicate()
	pos = Position
	root = Root
	node.position = pos
	root.add_child.call_deferred(node)

func spawn_nodes(Spawns:Array, Positions: Array, Root:Node2D = self):
	for i in range(Spawns.size()):
		if Positions.size() > Spawns.size():
			spawn_node(Spawns[i], Positions[0], Root)
		else:
			spawn_node(Spawns[i], Positions[i], Root)
