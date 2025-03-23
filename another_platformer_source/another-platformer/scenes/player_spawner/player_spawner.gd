class_name PlayerSpawner extends Marker2D

@export var player_scene: PackedScene

func _ready() -> void:
	if not player_scene:
		printerr("Player scene not provided to PlayerSpawner")
		
	await owner.ready
	
	SignalBus.respawn_player.connect(spawn_player)
	
	spawn_player()
	

func spawn_player() -> void:
	var player: Player = player_scene.instantiate()
	owner.add_child(player)
	player.global_position = global_position
