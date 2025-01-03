extends Node

@onready var sfx_audio_stream_player_2d: AudioStreamPlayer2D = %SfxAudioStreamPlayer2D

@export var key_pick_up: AudioStream
@export var explosion: AudioStream
@export var jump: AudioStream
@export var level_exit: AudioStream

func play_coin_pickup() -> void:
	sfx_audio_stream_player_2d.stream = key_pick_up
	sfx_audio_stream_player_2d.play()


func play_explosion() -> void:
	sfx_audio_stream_player_2d.stream = explosion
	sfx_audio_stream_player_2d.play()

func play_jump() -> void:
	sfx_audio_stream_player_2d.stream = jump
	sfx_audio_stream_player_2d.play()
	
func play_exit() -> void:
	sfx_audio_stream_player_2d.stream = level_exit
	sfx_audio_stream_player_2d.play()
