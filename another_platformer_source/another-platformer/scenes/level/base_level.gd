class_name BaseLevel
extends Node


func _ready() -> void:
	SignalBus.exit_reached.connect(_handle_exit_reached)
	

func _handle_exit_reached() -> void:
	Logger.create("BaseLevel._exit_reached", "Received exit signal")
	SceneManager.load_next_level()
