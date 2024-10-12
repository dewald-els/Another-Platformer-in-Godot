extends Node

signal resume_player
signal pause_player
signal exit_reached

func emit_exit_reached() -> void:
	exit_reached.emit()

func emit_pause_player() -> void:
	pause_player.emit()

func emit_resume_player() -> void:
	resume_player.emit()
