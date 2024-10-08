class_name Notification
extends CanvasLayer

signal on_dismiss

@onready var text_label: Label = %TextLabel

var text: String = ""

func _ready() -> void:
	text_label.text = text
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		on_dismiss.emit()
