class_name BaseLevel
extends Node

@onready var level_exit: LevelExit = %LevelExit


func _ready() -> void:
	level_exit.exit_reached.connect(_handle_exit_reached)
	

func _handle_exit_reached() -> void:
	SceneManager.load_next_level()
