class_name SpikeCannon
extends Node2D

@onready var shoot_timer: Timer = %ShootTimer

@export_enum("Left", "Right") var shoot_direction = "Right"
@export var bullet_scene: PackedScene
@export var shoot_interval: float = 1.0
@export var bullet_speed: float = 100.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot_timer.timeout.connect(_handle_shoot_timer_timeout)
	
func _shoot() -> void:
	var bullet_instance: SpikeCannonBullet = bullet_scene.instantiate()
	var projectiles_container = get_tree().get_first_node_in_group("projectiles")
	bullet_instance.direction = _direction_to_int()
	bullet_instance.speed = bullet_speed
	projectiles_container.add_child(bullet_instance)
	
func _direction_to_int() -> int:
	if shoot_direction == "Left":
		return -1
	else:
		return 1

func _handle_shoot_timer_timeout() -> void:
	_shoot()
