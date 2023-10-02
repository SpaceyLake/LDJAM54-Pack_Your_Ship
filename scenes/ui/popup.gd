extends Node2D
class_name PopupDialog

@export var text: Array = []
@export var timer: Timer
@export var text_holder: RichTextLabel
@export var animation_player: AnimationPlayer
@export var audios:Array[AudioStream]

@export var text_delay: float = 5
@export var character_delay: float = 0.1

var open = false
var writing = false


func _ready():
	Global.popup = self
	timer.timeout.connect(Callable(self,"_on_timer_timeout"))
	$moving/Area2DClose.input_event.connect(Callable(self, "_on_button_close"))
	$moving/Area2DNext.input_event.connect(Callable(self, "_on_button_next"))

func _exit():
	Global.popup = null

#DEBUG TEST CODE!!!
func _input(event):
	if event.is_action_pressed("ui_accept"):
		queue_text("HELLO HUMAN THIS IS YOUR CAPTAIN M4RV1N SPEAKING!!!")

func queue_text(new_text: String):
	if !open:
		_open()
	text.append(new_text)

func next_text():
	if text.is_empty():
		close()
		return
	text_holder.set_text(text[0])
	text.remove_at(0)
	text_holder.visible_characters = 0
	writing = true
	_on_timer_timeout()

func close():
	timer.stop()
	text.clear()
	text_holder.visible_characters = 0
	animation_player.play_backwards("popup")
	open = false
	writing = false

func _open():
	open = true
	animation_player.play("popup")
	timer.start(3)

func _on_timer_timeout():
	if !writing:
		next_text()
		return
	if text_holder.visible_ratio < 1:
		$AudioStreamPlayer.stream = audios.pick_random()
		$AudioStreamPlayer.play(0)
		text_holder.visible_characters = text_holder.visible_characters+1
		timer.start(character_delay)
	else:
		writing = false
		timer.start(text_delay)

func _on_button_next(_viewport, event, _shape_index):
	if (event is InputEventMouseButton && event.is_released()):
		if writing:
			text_holder.visible_ratio = 1
		else:
			next_text()

func _on_button_close(_viewport, event, _shape_index):
	if (event is InputEventMouseButton && event.is_released()):
		close()
