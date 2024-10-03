class_name Health
extends Node


signal health_changed
signal health_decreased
signal died


@export var max_health: float = 10.0

var current_health: float = 0.0

func _ready() -> void:
	current_health = max_health


func damage(amount_of_damage: float) -> void:
	current_health = clamp(current_health - amount_of_damage, 0, max_health)
	health_changed.emit()
	if amount_of_damage > 0:
		health_decreased.emit()
	if current_health == 0:
		Callable(_die).call_deferred()


func get_health_perentage() -> float:
	if max_health <= 0:
		return 0
	
	return min(current_health / max_health, 1)

func _die() -> void:
	died.emit()
	if owner:
		owner.queue_free()


func heal(heal_amount: float) -> void:
	damage(-heal_amount)
