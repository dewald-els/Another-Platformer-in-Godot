extends CanvasLayer

@onready var splash_timer: Timer = %SplashTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	splash_timer.timeout.connect(_handle_timeout)


func _handle_timeout() -> void:
	SceneManager.load_scene(SceneManager.Screens.MainMenu)
