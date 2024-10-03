extends Node


func create(function: String, message: String) -> void:
	var current_time = "  "
	var print_message = "[" + function + "]" + current_time + message
	print(print_message)
