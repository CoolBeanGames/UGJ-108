extends NavigationRegion3D
@export var bird_player : audio_player
@export var music_player : audio_player


func _ready() -> void:
	$game_map/day_night_cycle.play("day")

func end_day(): 
	Autoload.references["screen_fade"].start_tween(1,true)

func start_birds():
	bird_player.play_sound()

func start_music():
	music_player.play_sound()
