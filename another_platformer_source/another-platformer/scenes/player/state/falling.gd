extends PlayerState

func enter(_prev_state: String, _data = {}) -> void:
	player.animated_sprite.play("jump")
	player.coyote_timer.start()
	

func get_gravity_multiplier() -> float:
	if Input.is_action_pressed("jump"):
		return player.jump_gravity_multiplier
	
	return player.fall_gravity_multiplier

func physics_update(delta: float) -> void:
	player.apply_gravity(delta, get_gravity_multiplier())
	
	var direction: float = player.get_movement_direction()
	var target_velocity: float = direction * player.max_speed
	player.velocity.x = lerp(player.velocity.x, target_velocity, 1 - exp(-player.acceleration * delta))
	
	player.move_and_slide()
	
	player.flip_player(direction)
	
	if Input.is_action_just_pressed("jump") and not player.coyote_timer.is_stopped():
		player.coyote_timer.stop()
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("jump"):
		player.jump_buffer_timer.start()
	elif player.is_on_floor() and not player.jump_buffer_timer.is_stopped():
		player.jump_buffer_timer.stop()
		finished.emit(JUMPING)
	elif player.is_on_floor():
		finished.emit(IDLE)
	elif player.is_on_ladder:
		finished.emit(CLIMBING)
