extends Node

signal key_collected

var _is_key_collected: bool = false

func has_key() -> bool:
	return _is_key_collected

func collect_key() -> void:
	_is_key_collected = true
	key_collected.emit()
