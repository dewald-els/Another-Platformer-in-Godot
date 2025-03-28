extends PlayerState
	
func physics_update(delta: float) -> void:
	var x_direction: float = player.get_movement_direction()
	var y_direction: float = player.get_climb_direction()
	player.velocity_component.accelerate(
		Vector2(
			x_direction,
			y_direction
		)
	)
	player.apply_gravity(delta, player.fall_gravity_multiplier)
	player.velocity_component.move(player)
	
	player.flip_player(x_direction)
	
	if not player.is_on_ladder:
		finished.emit(FALLING)
