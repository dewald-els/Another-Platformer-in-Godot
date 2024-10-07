class_name Player
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite
@onready var health: Health = %Health
@onready var ladder_area_2d: Area2D = %LadderArea2D


@export_group("Movement")
## How quickly the player can get to the maximum speed.
@export var acceleration: float = 5.0
## Maximum speed that player can move.
@export var max_speed: int = 40
@export var max_ladder_speed: int = 30
@export var max_climb_speed: int = 40

@export_group("Jump")
## How many blocks (16 pixels) should you jumps
@export var jump_height_in_units: float = 3.0
## Gravity while holding down the jump button
@export var fall_gravity_multiplier: float = 1.5
## Gravity when releasing the jump button
@export var jump_gravity_multiplier: float = 0.85
## Number of times the player can jump without landing on the floor.
@export var max_jumps: int = 2


var is_on_ladder: bool = false
var jump_count: int = 0
# 1 Unit = 80 = 16px 
var jump_velocity: float = -(5 * jump_height_in_units * 16)

var _start_position: Vector2

func _ready() -> void:
	Logger.create("Player._ready: ", "Jump velocity: " + str(jump_velocity))
	_start_position = global_position
	health.died.connect(_handle_died)
	ladder_area_2d.body_entered.connect(_handle_ladder_entered)
	ladder_area_2d.body_exited.connect(_handle_ladder_exit)


func _physics_process(delta: float) -> void:
	
	apply_gravity(delta)
	
	jump()
	
	var direction = get_movement_direction()
	
	if direction:
		accelerate(direction)
	else:
		stop()
		
	var climb_direction = get_climb_direction()
	
	if climb_direction:
		climb(climb_direction)
	elif is_on_ladder:
		stop_climb()

	move_and_slide()

	play_animation()
	

func play_animation() -> void:
	var move_speed = abs(velocity.x)

	if is_on_floor():
		if move_speed > 0.1:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
	elif not is_on_floor():
		animated_sprite.play("jump")
	

func get_movement_direction() -> float:
	var direction := Input.get_axis("move_left", "move_right")
	return direction
	

func get_climb_direction() -> float:
	if not is_on_ladder:
		return 0
		
	var direction := Input.get_axis("move_up", "move_down")
	return direction
	
	
func jump() -> void:
	if is_on_ladder:
		return 
	
	if is_on_floor():
		jump_count = 0
	
	if Input.is_action_just_pressed("jump") and (jump_count < max_jumps or is_on_floor()):
		velocity.y = jump_velocity
		jump_count += 1
	
func apply_gravity(delta: float) -> void:
	if not is_on_floor() and not is_on_ladder:
		if Input.is_action_pressed("jump") and jump_count <= 1:
			velocity.y += get_gravity().y * jump_gravity_multiplier * delta
		else:
			velocity.y += get_gravity().y * fall_gravity_multiplier * delta

func accelerate(direction: float) -> void:
	var target_velocity: float = direction * max_speed
	if is_on_ladder:
		target_velocity = direction * max_ladder_speed
	velocity.x = lerp(velocity.x, target_velocity, 1 - exp(-acceleration * get_process_delta_time()))
	
func climb(direction: float) -> void:
	if not is_on_ladder:
		return
		
	var target_velocity: float = direction * max_climb_speed
	velocity.y = lerp(velocity.y, target_velocity, 1 - exp(-acceleration * get_process_delta_time()))

func stop() -> void:
	accelerate(0.0)
	
func stop_climb() -> void:
	var target_velocity: float = 0.0 * max_speed
	velocity.y = lerp(velocity.y, target_velocity, 1 - exp(-acceleration * get_process_delta_time()))
	
	
func _handle_died() -> void:
	Logger.create("Player._handle_died", "resetting to " + str(_start_position))
	global_position = _start_position
	

func _handle_ladder_exit(_other_body: Node2D) -> void:
	Logger.create("Player._handle_ladder_exit", _other_body.name)
	is_on_ladder = false

func _handle_ladder_entered(_other_body: Node2D) -> void:
	Logger.create("Player._handle_ladder_entered", _other_body.name)
	is_on_ladder = true
	
