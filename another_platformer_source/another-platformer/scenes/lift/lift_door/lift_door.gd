class_name LiftDoor
extends CharacterBody2D

var starting_position_y: float = 0.0

func _ready() -> void:
	starting_position_y = global_position.y

func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)
