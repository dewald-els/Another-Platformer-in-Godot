extends PlayerState

var jump_count: int = 0

func enter(prev_state: String, data = {}) -> void:
	player.velocity.y = player.jump_velocity
	jump_count += 1
	SfxPlayer.play_jump()


func physics_update(delta: float) -> void:
	player.move_and_slide()
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif player.is_on_ladder:
		finished.emit(CLIMBING)
