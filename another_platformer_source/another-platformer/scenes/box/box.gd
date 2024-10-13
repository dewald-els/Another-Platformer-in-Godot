class_name Box
extends CharacterBody2D

@onready var pushing_area_2d: Area2D = %PushingArea2D

@export var gravity_multiplier: float = 0.95

var movement_speed: float = 0.0
var being_pushed: bool = false

var movement_vector: Vector2 = Vector2.ZERO

func _ready() -> void:
	pushing_area_2d.body_entered.connect(_handle_player_pushing)
	pushing_area_2d.body_exited.connect(_handle_player_not_pushing)
	

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	move_and_slide()
	
	
func _apply_gravity(delta: float) -> void:
	velocity.y += get_gravity().y * gravity_multiplier * delta
	
	
func _handle_player_pushing(body: Node2D) -> void:
	if not body:
		return 
	
	if "Player" in body.name:
		var player = body as Player
		velocity.x = player.max_push_speed * player.get_movement_direction()
	
func _handle_player_not_pushing(body: Node2D) -> void:
	if not body:
		return 
	
	if "Player" in body.name:
		velocity.x = 0
