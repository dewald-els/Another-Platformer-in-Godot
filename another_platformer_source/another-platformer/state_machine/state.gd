class_name State extends Node

signal finished(_next_state_path: String, _data: Dictionary)

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	pass
	
func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
	

func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	pass
