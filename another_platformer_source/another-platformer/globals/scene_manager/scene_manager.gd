extends Node

enum Screens {
	MainMenu,
	Splash,
	Pause,
	GameComplete
}


@export var _levels: Array[PackedScene] = []
@export var _main_menu: PackedScene
@export var _splash_screen: PackedScene
@export var _pause_screen: PackedScene
@export var _game_complete_screen: PackedScene

var _current_level_index: int = 0
	
	
func load_next_level() -> void:
	Logger.create("load_next_level", "Current_Level " + str(_current_level_index))
	Logger.create("load_next_level", "Total levels " + str(_levels.size()))
	if _levels.size() > _current_level_index:
		var scene = _levels[_current_level_index]
		Callable(_load_packed_scene.bind(scene)).call_deferred()
		_current_level_index += 1
	else:
		load_scene(Screens.GameComplete)
		
func _load_packed_scene(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)

func load_previous_level() -> void:
	if _current_level_index > 0:
		get_tree().change_scene_to_packed(_levels[_current_level_index - 1])
		_current_level_index -= 1
		
		
func reset_current_level() -> void:
	_current_level_index = 0
	

func set_next_level_index(index: int) -> void:
	if index > _levels.size():
		Logger.create("SceneManager.set_current_level_index", "The index " + str(index) + " is greater than the number of levels " + str(_levels.size()))
	_current_level_index = index
		
func load_scene(screen: Screens, as_child: bool = false) -> void:
	
	var scene_to_load: PackedScene
	
	match (screen):
		Screens.MainMenu:
			scene_to_load = _main_menu
		Screens.Splash:
			scene_to_load = _splash_screen
		Screens.Pause:
			scene_to_load = _pause_screen
		Screens.GameComplete:
			scene_to_load = _game_complete_screen
			
	if as_child:
		var scene_instance = scene_to_load.instantiate()
		get_tree().add_child(scene_instance)
		if scene_instance.has_signal("on_close"):
			scene_instance.on_close.connect(func():
				get_tree().remove_child(scene_instance)
			)
		
	else:
		Callable(_load_packed_scene.bind(scene_to_load)).call_deferred()
	
