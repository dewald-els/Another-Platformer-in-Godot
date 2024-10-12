class_name Lift
extends Node2D


@onready var platform_body_2d: CharacterBody2D = %PlatformBody2D
@onready var object_detection_area_2d: Area2D = %ObjectDetectionArea2D

@export var move_speed: float = 30.0
@export var max_distance: float = 100.0

var starting_position: Vector2
var object_is_on_platform: bool = false

var total_objects_on_platform: int = 0


func _ready() -> void:
	starting_position = platform_body_2d.global_position
	object_detection_area_2d.body_entered.connect(_handle_object_entered)
	object_detection_area_2d.body_exited.connect(_handle_object_exited)

func _distance_travelled() -> float:
	var distance_travelled = abs(platform_body_2d.global_position.y) - abs(starting_position.y)
	return distance_travelled

func _physics_process(_delta: float) -> void:
	if object_is_on_platform and _distance_travelled() < max_distance:
		platform_body_2d.velocity.y = move_speed
		platform_body_2d.move_and_slide()
	elif not object_is_on_platform and _distance_travelled() > 0:
		platform_body_2d.velocity.y = -move_speed
		platform_body_2d.move_and_slide()
	else:
		platform_body_2d.velocity.y = 0

func _handle_object_exited(_other_body: Node2D) -> void:
	total_objects_on_platform -= 1
	if total_objects_on_platform == 0:
		object_is_on_platform = false
	

func _handle_object_entered(_other_body: Node2D) -> void:
	total_objects_on_platform += 1
	object_is_on_platform = true
