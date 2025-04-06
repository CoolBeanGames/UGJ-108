extends collision_area

@export var money_sound_player : audio_player

func action():
	if(game_data.read_data("corn") > 0):
		while game_data.read_data("corn") > 0:
			game_data.store_data("corn",game_data.read_data("corn") - 1)
			game_data.store_data("coins",game_data.read_data("coins") + 1)
		super.action()
		money_sound_player.play_sound()

func _on_body_entered(body: Node3D) -> void:
	print("body entered " , body)
	super._on_body_entered(body)


func _on_body_exited(body: Node3D) -> void:
	
	super._on_body_exited(body)
