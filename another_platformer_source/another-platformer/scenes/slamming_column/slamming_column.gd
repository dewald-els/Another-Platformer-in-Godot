class_name SlammingColumn
extends StaticBody2D

@onready var delay_timer: Timer = %DelayTimer
@onready var withdraw_delay_timer: Timer = %WithdrawDelayTimer
@onready var damage_area_collision: CollisionShape2D = %DamageAreaCollision


const COLUMN_HEIGHT: int = 48

@export var start_delay: float = 0.01
@export var withdraw_duration: float = 4.0
@export var withdraw_delay: float = 0.01
@export var slam_speed: float = 0.25
@export_enum("UP", "DOWN") var direction = "DOWN"

var start_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position
	
	delay_timer.wait_time = start_delay
	delay_timer.timeout.connect(_handle_delay_timer_timeout)
	
	withdraw_delay_timer.wait_time = withdraw_delay
	withdraw_delay_timer.timeout.connect(_handle_withdraw_delay_timeout)
	
	delay_timer.start()
	
	
func _handle_delay_timer_timeout() -> void:
	_slam()
	
func _handle_withdraw_delay_timeout() -> void:
	damage_area_collision.disabled = true
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", start_position, withdraw_duration)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
		
	tween.tween_callback(_restart_timer)

func _slam() -> void:
	damage_area_collision.disabled = false
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", global_position + (Vector2.DOWN * COLUMN_HEIGHT), slam_speed)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
		
	withdraw_delay_timer.start()
	
func _restart_timer() -> void:
	delay_timer.start()
