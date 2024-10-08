extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.reset_current_level()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		SceneManager.load_scene(SceneManager.Screens.Splash)
