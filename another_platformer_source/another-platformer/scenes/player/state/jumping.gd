extends PlayerState

var jump_count: int = 0

func enter(_prev_state: String, _data = {}) -> void:
	player.velocity.y = player.jump_velocity
	jump_count += 1
	SfxPlayer.play_jump()


func physics_update(_delta: float) -> void:
	player.move_and_slide()
	
	var direction = player.get_movement_direction()
	player.flip_player(direction)
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif player.is_on_ladder:
		finished.emit(CLIMBING)
