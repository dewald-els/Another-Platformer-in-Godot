class_name Key
extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Logger.create("Key._ready", "Exit setup")
	area_entered.connect(_on_area_entered)


func _on_area_entered(_other_body: Area2D) -> void:
	Logger.create("_on_body_entered", "collected the key")
	KeyManager.collect_key()
	queue_free()
