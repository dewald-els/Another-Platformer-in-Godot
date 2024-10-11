class_name SpikeCannonBullet
extends Node2D

@onready var destroy_timer: Timer = %DestroyTimer
@onready var sprite_2d: Sprite2D = %Sprite2D

var speed: float = 5.0
var direction: int = 0
var destroy_wait_time: float = 1.0

func _ready() -> void:
	Logger.create("Bullet", "direction: " + str(direction))
	Logger.create("Bullet", "speed: " + str(speed))
	destroy_timer.timeout.connect(_handle_destroy_timeout)
	destroy_timer.wait_time = destroy_wait_time
	destroy_timer.start()
	scale.x = direction
		

func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta


func _handle_destroy_timeout() -> void:
	call_deferred("queue_free")
