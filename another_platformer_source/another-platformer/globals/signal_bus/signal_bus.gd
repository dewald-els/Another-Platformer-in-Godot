extends Node

signal exit_reached

func emit_exit_reached() -> void:
	exit_reached.emit()
