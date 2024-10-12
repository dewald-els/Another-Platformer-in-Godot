extends BaseLevel

func _ready() -> void:
	super()
	SceneManager.set_next_level_index(7)
	
	var player = get_tree().get_first_node_in_group("player") as Player
	
	if player:
		player.health.died.connect(_handle_player_died)
		
	

func _handle_player_died() -> void:
	get_tree().reload_current_scene()
