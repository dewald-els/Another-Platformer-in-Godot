class_name BaseLevel
extends Node

var reload_on_player_death: bool = false

func _ready() -> void:
	SignalBus.exit_reached.connect(_handle_exit_reached)
	
	var player = get_tree().get_first_node_in_group("player") as Player
	
	if player:
		player.health.died.connect(_handle_player_died)

func set_level_index(index: int) -> void:
	SceneManager.set_next_level_index(index)

func _handle_exit_reached() -> void:
	Logger.create("BaseLevel._exit_reached", "Received exit signal")
	SceneManager.load_next_level()


func _handle_player_died() -> void:
	if reload_on_player_death:
		get_tree().reload_current_scene()
 
