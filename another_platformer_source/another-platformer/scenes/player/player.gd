class_name Player
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite
@onready var health: Health = %Health


@export_group("Movement")
## How quickly the player can get to the maximum speed.
@export var acceleration: float = 5.0
## Maximum speed that player can move.
@export var max_speed: int = 40
@export_group("Jump")
## How many blocks (16 pixels) should you jumps
@export var jump_height_in_units: float = 3.0
## Gravity while holding down the jump button
@export var fall_gravity_multiplier: float = 1.5
## Gravity when releasing the jump button
@export var jump_gravity_multiplier: float = 0.85
## Number of times the player can jump without landing on the floor.
@export var max_jumps: int = 2


var jump_count: int = 0
# 1 Unit = 80 = 16px 
var jump_velocity: float = -(5 * jump_height_in_units * 16)

var _start_position: Vector2

func _ready() -> void:
	Logger.create("Player._ready: ", "Jump velocity: " + str(jump_velocity))
	_start_position = global_position
	health.died.connect(_handle_died)


func _physics_process(delta: float) -> void:
	
	apply_gravity(delta)
	
	jump()
	
	var direction = get_movement_vector()
	
	if direction:
		accelerate(direction)
	else:
		stop()

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
	

func get_movement_vector() -> float:
	var direction := Input.get_axis("move_left", "move_right")
	return direction

func jump() -> void:
	if is_on_floor():
		jump_count = 0
	
	if Input.is_action_just_pressed("jump") and (jump_count < max_jumps or is_on_floor()):
		velocity.y = jump_velocity
		jump_count += 1
	
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		if Input.is_action_pressed("jump") and jump_count <= 1:
			velocity.y += get_gravity().y * jump_gravity_multiplier * delta
		else:
			velocity.y += get_gravity().y * fall_gravity_multiplier * delta

func accelerate(direction: float) -> void:
	var target_velocity: float = direction * max_speed
	velocity.x = lerp(velocity.x, target_velocity, 1 - exp(-acceleration * get_process_delta_time()))

func stop() -> void:
	accelerate(0.0)
	
	
func _handle_died() -> void:
	Logger.create("Player._handle_died", "resetting to " + str(_start_position))
	global_position = _start_position
	
	

	
