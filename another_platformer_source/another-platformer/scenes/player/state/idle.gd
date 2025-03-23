class_name PlayerIdleState
extends PlayerState


func enter(_previous_state_path: String, _data := {}) -> void:
	player.velocity.x = 0.0
	player.animated_sprite.play("idle")


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()

	_update_state()
		
func _update_state() -> void:
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		finished.emit(RUNNING)
