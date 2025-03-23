class_name BaseLevel
extends Node

var reload_on_player_death: bool = false

func _ready() -> void:
	SignalBus.exit_reached.connect(_handle_exit_reached)
	SignalBus.respawn_player.connect(_handle_respawn_player)

func set_level_index(index: int) -> void:
	SceneManager.set_next_level_index(index)

func _handle_exit_reached() -> void:
	Logger.create("BaseLevel._exit_reached", "Received exit signal")
	SceneManager.load_next_level()


func _handle_respawn_player() -> void:
	if reload_on_player_death:
		get_tree().reload_current_scene()
 
