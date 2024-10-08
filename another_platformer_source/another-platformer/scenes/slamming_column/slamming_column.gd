class_name SlammingColumn
extends StaticBody2D

signal withdraw_complete
signal slam_complete

@onready var damage_area_collision: CollisionShape2D = %DamageAreaCollision

const COLUMN_HEIGHT: int = 49 # + 1 Pixel for hiding behind Platforms

var is_withdrawing: bool = false
var withdraw_duration: float = 4.0
var slam_speed: float = 0.25

@export_enum("UP", "DOWN") var direction = "DOWN"

var start_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	start_position = global_position
	
	
func withdraw() -> void:
	is_withdrawing = true
	damage_area_collision.disabled = true
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", start_position, withdraw_duration)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_callback(_handle_withdraw_complete)

func slam() -> void:
	if is_withdrawing:
		return
		
	damage_area_collision.disabled = false
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", global_position + (Vector2.DOWN * COLUMN_HEIGHT), slam_speed)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_callback(_handle_slam_complete)
	
	
func _handle_slam_complete() -> void:
	slam_complete.emit()

func _handle_withdraw_complete() -> void:
	is_withdrawing = false
	withdraw_complete.emit()
