class_name Key
extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Logger.create("_on_body_entered", "collected the key")
		KeyManager.collect_key()
		queue_free()
