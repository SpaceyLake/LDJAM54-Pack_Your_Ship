extends Node2D
class_name Enemy

var goal:Vector2
var enemy_killed_signal:Signal

func setup(goal:Vector2, enemy_killed_signal:Signal):
	self.goal = goal
	self.enemy_killed_signal = enemy_killed_signal
