class_name NotificationTrigger
extends Area2D

@export var notification_scene: PackedScene
@export var one_time_notification: bool = true
@export var pause_while_open: bool = true
@export var notification_text: String = ""

var scene_instance: Notification

func _ready() -> void:
	Logger.create("NotificationTrigger._ready", "Text is: " + notification_text)
	body_entered.connect(_handle_area_entered)


func _handle_area_entered(_other_area: Node2D) -> void:
	if "Player" not in _other_area.name:
		return
		
	scene_instance = notification_scene.instantiate()
	scene_instance.text = notification_text
	scene_instance.on_dismiss.connect(_handle_notification_dismiss)
	add_child(scene_instance)
	
	
	if pause_while_open: 
		get_tree().paused = true


func _handle_notification_dismiss() -> void:
	
	if pause_while_open: 
		get_tree().paused = false
	
	if one_time_notification:
		queue_free()
	else:
		scene_instance.queue_free()
