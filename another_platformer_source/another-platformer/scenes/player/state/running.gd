extends PlayerState


func enter(prev: String, data = {}) -> void:
	player.animated_sprite.play("run")

func physics_update(delta: float) -> void:
	var direction: float = player.get_movement_direction()
	player.velocity_component.accelerate(Vector2(direction, 1))
	player.apply_gravity(delta)
	player.velocity_component.move(player)

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump") and player.is_on_floor():
		finished.emit(JUMPING)
	elif direction == 0:
		finished.emit(IDLE)
	
