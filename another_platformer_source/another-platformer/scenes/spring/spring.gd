class_name Spring
extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var jump_pad_area_2d: Area2D = %JumpPadArea2D

@export var pad_velocity_in_units: int = 10

var pad_velocity: float = 10.0

func _ready() -> void:
	pad_velocity = - (5 * pad_velocity_in_units * 16)
	jump_pad_area_2d.body_entered.connect(_on_player_entered_jump_pad)
	
func _on_player_entered_jump_pad(body: Node2D) -> void:
	if not body:
		return
	
	animated_sprite_2d.play("spring")
	var player = body as Player
	player.apply_jump(pad_velocity)
