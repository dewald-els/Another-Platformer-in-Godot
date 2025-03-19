extends PlayerState

func enter(prev: String, data = {}) -> void:
	player.velocity.x = 0.0
	player.animated_sprite.play("idle")
	
