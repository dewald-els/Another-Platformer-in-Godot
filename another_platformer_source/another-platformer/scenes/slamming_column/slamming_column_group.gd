class_name SlammingColumnGroup
extends Node2D

@onready var start_delay_timer: Timer = %StartDelayTimer

@export var start_delay_time: float = 0.0

@export var withdraw_duration: float = 4.0
@export var withdraw_delay: float = 0.0
@export var slam_speed: float = 0.25
@export_enum("Wait", "OnSlam", "Together") var slam_pattern = "Wait"

var columns: Array[SlammingColumn] = []
var current_column_index: int = 0
var total_withdrawn: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	_find_columns_in_group()
	
	if start_delay_time == 0.0:
		start_delay_time = randf_range(0.1, 1.0)
		
	start_delay_timer.wait_time = start_delay_time
	start_delay_timer.timeout.connect(_handle_delay_timer_timeout)
	start_delay_timer.start()
	
func _find_columns_in_group() -> void:
	for child in get_children():
		if "SlammingColumn" in child.name:
			columns.append(child as SlammingColumn)
			
	var column_index: int = 0
	for column in columns:
		column.withdraw_duration = withdraw_duration
		column.slam_speed = slam_speed
		column.slam_complete.connect(func(): _handle_slam_complete(column_index))
		column.withdraw_complete.connect(func(): _handle_withdraw_complete(column_index))
		column_index += 1


func _handle_withdraw_complete(_index: int) -> void:
	if slam_pattern == "Wait":
		_slam_next_column()
	
	total_withdrawn += 1
	
	if slam_pattern == "Together" and total_withdrawn == columns.size():
		total_withdrawn = 0
		_slam_all_columns()


func _handle_slam_complete(index: int) -> void:
	
	columns[index].withdraw()
	
	if slam_pattern == "OnSlam":
		_slam_next_column()


# Can't get the withdraw delay to work as expected.
#func _withdraw_column(index: int) -> void:
	#if withdraw_delay > 0.0:
		#await get_tree().create_timer(withdraw_delay).timeout
		#columns[index].withdraw()
	#else:
		#columns[index].withdraw()

func _slam_next_column() -> void:
	var column = columns[current_column_index]
	if not column.is_withdrawing:
		column.slam()
		current_column_index += 1
		
		if current_column_index == columns.size():
			current_column_index = 0

func _slam_all_columns() -> void:
	for column in columns:
		column.slam()

func _handle_delay_timer_timeout() -> void:
	if columns.size() <= 0:
		return

	if slam_pattern == "Together":
		_slam_all_columns()
	else:
		_slam_next_column()
	
