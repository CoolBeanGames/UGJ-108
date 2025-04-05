extends Node3D

@export var walk_sound_left : audio_player
@export var walk_sound_right : audio_player

func play_left():
	walk_sound_left.play_sound()

func play_right():
	walk_sound_right.play_sound()
