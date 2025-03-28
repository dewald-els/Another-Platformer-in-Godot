extends PlayerState

func enter(_prev: String, _data = {}) -> void:
	player.velocity.x = 0.0
	player.animated_sprite.play("idle")
	
func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()