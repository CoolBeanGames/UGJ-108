extends dialog_line
class_name voiced_line

@export var audio_file : AudioStreamMP3
@export var audio_length : float
@export var end_after_audio : bool = true

func init():
	audio_length = audio_file.get_length()
