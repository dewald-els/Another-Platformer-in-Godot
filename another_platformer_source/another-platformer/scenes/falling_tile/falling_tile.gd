class_name FallingTile
extends StaticBody2D


@onready var falling_tile_area_2d: Area2D = %FallingTileArea2D
@onready var fall_timer: Timer = %FallTimer
@onready var destroy_timer: Timer = %DestroyTimer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var collider_2d: CollisionShape2D = %Collider2D

@export var time_before_falling: float = 1.0
@export var time_before_destroy: float = 1.0

var _is_falling: bool = false


var FALL_SPEED:float = 250.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	fall_timer.wait_time = time_before_falling
	destroy_timer.wait_time = time_before_destroy
	
	fall_timer.timeout.connect(_handle_fall_timer_timeout)
	destroy_timer.timeout.connect(_handle_destroy_timer_timeout)
	falling_tile_area_2d.body_entered.connect(_handle_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _is_falling:
		position.y += FALL_SPEED * delta
	
	
func _handle_destroy_timer_timeout() -> void:
	call_deferred("queue_free")
	
func _handle_fall_timer_timeout() -> void:
	_is_falling = true
	destroy_timer.start()
	Callable(_disable_collision).call_deferred()


func _disable_collision() -> void:
	collider_2d.disabled = true

func _handle_body_entered(body: Node2D) -> void:
	if "Player" not in body.name:
		return
	
	fall_timer.start()
	animation_player.play("jiggle")
