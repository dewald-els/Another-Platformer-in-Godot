extends PlayerState

func enter(prev_state: String, data = {}) -> void:
	player.animated_sprite.play("jump")
	player.coyote_timer.start()
	
	
func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	
	var direction: float = player.get_movement_direction()
	var target_velocity: float = direction * player.max_speed
	player.velocity.x = lerp(player.velocity.x, target_velocity, 1 - exp(-player.acceleration * delta))
	
	player.move_and_slide()
	
	if Input.is_action_just_pressed("jump") and not player.coyote_timer.is_stopped():
		player.coyote_timer.stop()
		finished.emit(JUMPING)
	
	if player.is_on_floor():
		finished.emit(IDLE)
	elif player.is_on_ladder:
		finished.emit(CLIMBING)
