class_name Player
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite
@onready var health: Health = %Health
@onready var ladder_area_2d: Area2D = %LadderArea2D
@onready var box_push_area_2d: Area2D = %BoxPushArea2D
@onready var visuals: Node2D = %Visuals
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var velocity_component: VelocityComponent = %VelocityComponent
@onready var state_machine: StateMachine = %StateMachine
@onready var jump_buffer_timer: Timer = %JumpBufferTimer


@export_group("Movement")
## How quickly the player can get to the maximum speed.
@export var acceleration: float = 5.0
## Maximum speed that player can move.
@export var max_speed: int = 40
@export var air_speed: int = 50
@export var max_push_speed: int = 25
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

@export var player_death_scene: PackedScene


const PUSH_FORCE: float = 1.5
const MIN_PUSH_FORCE: float = 0.15

var is_pushing_body: bool = false
var is_on_ladder: bool = false
var jump_count: int = 0
# 1 Unit = 80 = 16px 
var jump_velocity: float = 0.0
var _start_position: Vector2

func _ready() -> void:
	jump_velocity = - (5 * jump_height_in_units * 16)
	Logger.create("Player._ready: ", "Jump units: " + str(jump_height_in_units))
	Logger.create("Player._ready: ", "Jump velocity: " + str(jump_velocity))
	_start_position = global_position
	
	velocity_component.acceleration = acceleration
	velocity_component.max_speed = max_speed
	
	SignalBus.pause_player.connect(_handle_pause_player)
	health.died.connect(_handle_died)
	ladder_area_2d.body_entered.connect(_handle_ladder_entered)
	ladder_area_2d.body_exited.connect(_handle_ladder_exit)
	box_push_area_2d.body_entered.connect(_handle_box_entered)
	box_push_area_2d.body_exited.connect(_handle_box_exited)


func play_animation() -> void:
	var move_speed = abs(velocity.x)

	if is_on_floor():
		#print("Is pushing?", str(is_pushing_body))
		if move_speed > 0.1 or is_pushing_body:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
	elif not is_on_floor():
		animated_sprite.play("jump")
	

func get_movement_direction() -> float:
	var direction := Input.get_axis("move_left", "move_right")
	return direction
	
func flip_player(direction: float) -> void:
	var move_sign: float = sign(direction)
	
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

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
		apply_jump(jump_velocity)
		jump_count += 1
		SfxPlayer.play_jump()
		
func apply_jump(apply_velocity: float) -> void:
	velocity.y = apply_velocity

func apply_gravity(delta: float, gravity_modifier: float = fall_gravity_multiplier) -> void:
	velocity.y += get_gravity().y * gravity_modifier * delta


func accelerate(direction: float) -> void:
	var target_velocity: float = direction * max_speed
	if is_on_ladder:
		target_velocity = direction * max_ladder_speed
	if is_pushing_body:
		target_velocity = direction * max_push_speed
		
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
	visuals.visible = false
	Logger.create("Player._handle_died", "resetting to " + str(_start_position))
	var death = player_death_scene.instantiate() as PlayerDeath
	get_tree().root.add_child(death)
	death.global_position = global_position
	Callable(queue_free).call_deferred()


func _handle_ladder_exit(_other_body: Node2D) -> void:
	Logger.create("Player._handle_ladder_exit", _other_body.name)
	is_on_ladder = false

func _handle_ladder_entered(_other_body: Node2D) -> void:
	Logger.create("Player._handle_ladder_entered", _other_body.name)
	is_on_ladder = true
	
func _handle_pause_player() -> void:
	print("Pause player")
	state_machine.state.finished.emit("Paused")
	
func _handle_box_entered(_other_body: Node2D) -> void:
	print("Pushing now?")
	is_pushing_body = true
	
func _handle_box_exited(_other_body: Node2D) -> void:
	is_pushing_body = false
