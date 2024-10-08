extends BaseLevel

func _ready() -> void:
	
	SceneManager.set_current_level_index(6)
	
	var player = get_tree().get_first_node_in_group("player") as Player
	if not player:
		return
		
	player.health.died.connect(_handle_player_died)


func _handle_player_died() -> void:
	get_tree().reload_current_scene()
