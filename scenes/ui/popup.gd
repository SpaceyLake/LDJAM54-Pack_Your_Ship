extends Node2D

@export var text:Array = []
@export var timer:Timer
@export var text_holder:TextEdit
@export var button:Button

func _ready():
	timer.timeout.connect(Callable(self,"show_popup"))
	timer.start(5)

func show_popup():
	if not text.is_empty():
		if not visible:
			visible = true
		
		text_holder.text = text[0]
		text.remove_at(0)
	else:
		visible = false


func _on_button_button_up():
	show_popup()
