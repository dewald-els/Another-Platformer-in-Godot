class_name Box
extends StaticBody2D

@onready var pushing_area_2d: Area2D = %PushingArea2D

@export var gravity_multiplier: float = 1.5

var movement_speed: float = 0.0

func _ready() -> void:
	pushing_area_2d.body_entered.connect(_handle_player_pushing)
	pushing_area_2d.body_exited.connect(_handle_player_not_pushing)
	

func _physics_process(delta: float) -> void:
	var movement: Vector2 = movement_speed * delta * Vector2.RIGHT
	print("box move" + str(movement)) 
	var moved = move_and_collide(
		movement
	)
	
func _handle_player_pushing(body: Node2D) -> void:
	if not body:
		return 
	
	if "Player" in body.name:
		Logger.create("Box._handle_player_pushing", "Player in contact")
		movement_speed = (body as Player).velocity.x
	
func _handle_player_not_pushing(body: Node2D) -> void:
	if not body:
		return 
	
	if "Player" in body.name:
		Logger.create("Box._handle_player_pushing", "Left contact")
		movement_speed = 0
