class_name Hurtbox
extends Area2D


@export var health: Health


func _ready() -> void:
	area_entered.connect(_handle_area_entered)


func _handle_area_entered(_other_body: Area2D) -> void:
	Logger.create("Hurtbox._handle_area_entered", "Some area entered the hurtbox")
	if health:
		health.damage(1)
