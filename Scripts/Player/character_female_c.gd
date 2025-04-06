extends Node3D

@export var walk_sound_left : audio_player
@export var walk_sound_right : audio_player
@export var weapon_swing_sound : audio_player

func play_left():
	walk_sound_left.play_sound()

func play_right():
	walk_sound_right.play_sound()

func play_swing_weapon():
	weapon_swing_sound.play_sound()


func _on_attack_enter(body: Node3D) -> void:
	
	pass # Replace with function body.


func _on_attack_exit(body: Node3D) -> void:
	pass # Replace with function body.
