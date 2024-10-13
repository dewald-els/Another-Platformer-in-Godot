class_name PlayerDeath
extends Node2D

signal respawn_player

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var explode_particles: GPUParticles2D = %ExplodeParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_handle_animation_ended)


func _destroy() -> void:
	queue_free()

func _handle_animation_ended() -> void:
	animated_sprite_2d.visible = false
	explode_particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	respawn_player.emit()
	Callable(_destroy).call_deferred()
	
