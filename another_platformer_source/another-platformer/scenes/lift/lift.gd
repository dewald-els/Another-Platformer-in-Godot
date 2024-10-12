class_name Lift
extends Node2D


@onready var platform_body_2d: CharacterBody2D = %PlatformBody2D
@onready var object_detection_area_2d: Area2D = %ObjectDetectionArea2D

@export var move_speed: float = 30.0
@export var max_distance: float = 100.0

var starting_position: Vector2
var object_is_on_platform: bool = false


func _ready() -> void:
	starting_position = platform_body_2d.global_position
	object_detection_area_2d.body_entered.connect(_handle_object_entered)
	object_detection_area_2d.body_exited.connect(_handle_object_exited)

func _distance_travelled() -> float:
	var distance_travelled = abs(platform_body_2d.global_position.y) - abs(starting_position.y)
	Logger.create("Lift.global_position", str(global_position))
	return distance_travelled

func _physics_process(_delta: float) -> void:
	if object_is_on_platform and _distance_travelled() < max_distance:
		Logger.create("Lift._physics_process", "Move down..")
		platform_body_2d.velocity.y = move_speed
		platform_body_2d.move_and_slide()
	elif not object_is_on_platform and _distance_travelled() > 0:
		Logger.create("Lift._physics_process", "Not On platform, and not at start position")
		platform_body_2d.velocity.y = -move_speed
		platform_body_2d.move_and_slide()
	else:
		platform_body_2d.velocity.y = 0

func _handle_object_exited(_other_body: Node2D) -> void:
	Logger.create("Lift._handle_object_exited", "Other Body: " + _other_body.name)
	object_is_on_platform = false

func _handle_object_entered(_other_body: Node2D) -> void:
	Logger.create("Lift._handle_object_entered", "Other Body: " + _other_body.name)
	object_is_on_platform = true
