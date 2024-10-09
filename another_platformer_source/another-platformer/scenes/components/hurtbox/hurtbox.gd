class_name Hurtbox
extends Area2D


@export var health: Health


func _ready() -> void:
	area_entered.connect(_handle_area_entered)
	body_entered.connect(_handle_body_entered)


func _handle_body_entered(_other_body: Node2D) -> void:
	Logger.create("Hurtbox._handle_body_entered", "Some area entered the hurtbox" + _other_body.name)
	if health:
		health.damage(1)

func _handle_area_entered(_other_body: Area2D) -> void:
	Logger.create("Hurtbox._handle_area_entered", "Some area entered the hurtbox")
	if health:
		health.damage(1)
