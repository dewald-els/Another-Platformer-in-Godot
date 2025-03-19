extends Node2D


@onready var debug_label: Label = %DebugLabel


@export var state_machine: StateMachine


func _process(delta: float) -> void:
	debug_label.text = state_machine.state.name
