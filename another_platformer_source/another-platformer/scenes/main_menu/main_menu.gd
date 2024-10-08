extends CanvasLayer

@onready var play_button: Button = %PlayButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.pressed.connect(_handle_play_pressed)
	play_button.grab_focus()
	quit_button.pressed.connect(_handle_quit_pressed)
	options_button.pressed.connect(_handle_options_pressed)
	
func _handle_play_pressed() -> void:
	SceneManager.load_next_level()
	
func _handle_quit_pressed() -> void:
	get_tree().quit()


func _handle_options_pressed() -> void:
	pass
