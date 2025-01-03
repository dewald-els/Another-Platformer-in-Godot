class_name LevelExit
extends Node2D


@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite
@onready var exit_area_2d: Area2D = %ExitArea2D


func _ready() -> void:
	exit_area_2d.body_entered.connect(_on_exit_entered)
	
func _on_exit_entered(body: Node2D) -> void:
	if not KeyManager.has_key():
		Logger.create("LevelExit._on_exit_entered", "No Key yet")
		return

	Logger.create("LevelExit._on_exit_entered", "Has Key")
	
	if body is Player:
		SfxPlayer.play_exit()
		SignalBus.emit_pause_player()
		animated_sprite.play("open")
		await animated_sprite.animation_finished
		SignalBus.emit_exit_reached()
