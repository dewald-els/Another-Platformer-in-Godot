class_name SpikeCannonBullet
extends CharacterBody2D

var speed: float = 5.0
var direction: int = 0


func _physics_process(delta: float) -> void:
	velocity.x = speed * direction * delta
