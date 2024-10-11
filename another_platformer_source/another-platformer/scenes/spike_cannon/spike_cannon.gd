class_name SpikeCannon
extends Node2D

@onready var shoot_timer: Timer = %ShootTimer
@onready var bullet_origin: Marker2D = %BulletOrigin

@export_enum("Left", "Right") var shoot_direction = "Right"
@export var bullet_scene: PackedScene
@export var shoot_interval: float = 1.0
@export var bullet_speed: float = 100.0
@export var destroy_bullet_after: float = 1.0


func _ready() -> void:
	shoot_timer.wait_time = shoot_interval
	shoot_timer.timeout.connect(_handle_shoot_timer_timeout)
	shoot_timer.start()
	
	
func _shoot() -> void:
	Logger.create("Cannon._shoot", "Shooting")
	var bullet_instance: SpikeCannonBullet = bullet_scene.instantiate()
	var projectiles_container = get_tree().get_first_node_in_group("projectiles")
	bullet_instance.direction = _direction_to_int()
	bullet_instance.speed = bullet_speed
	bullet_instance.destroy_wait_time = destroy_bullet_after
	projectiles_container.add_child(bullet_instance)
	bullet_instance.global_position = bullet_origin.global_position
	shoot_timer.start()
	
func _direction_to_int() -> int:
	if shoot_direction == "Left":
		return -1
	else:
		return 1

func _handle_shoot_timer_timeout() -> void:
	_shoot()
