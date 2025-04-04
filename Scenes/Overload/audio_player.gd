extends AudioStreamPlayer
class_name audio_player

enum audio_type{sound_effect,music,vocal}
@export var type : audio_type
@export_range(-80,24) var volume : float 
@export var randomize_pitch : bool = false
@export var pitch_range : Vector2 = Vector2(.9,1.1)


func play_sound():
	var value : float = 0
	if type == audio_type.sound_effect:
		value = Autoload.read_setting("sfx_volume")
	if type == audio_type.music:
		value = Autoload.read_setting("music_volume")
	if type == audio_type.vocal:
		value = Autoload.read_setting("vocal_volume")
	volume_db = volume * (value * Autoload.read_setting("master_volume"))
	if randomize_pitch:
		var rand = RandomNumberGenerator.new()
		pitch_scale = rand.randf_range(pitch_range.x,pitch_range.y)
	play()
