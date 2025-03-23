extends PlayerState

func enter(prev_state: String, data = {}) -> void:
	pass
	
func physics_update(delta: float) -> void:
	var direction: float = player.get_movement_direction()
	var climb_direction: float = player.get_climb_direction()
	player.velocity_component.accelerate(
		Vector2(
			direction,
			climb_direction
		)
	)
	player.apply_gravity(delta)
	player.velocity_component.move(player)
	
	if not player.is_on_ladder:
		finished.emit(FALLING)
