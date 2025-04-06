extends Resource
class_name conversation

@export var lines : Array[dialog_line] = []
@export var typerwriter_effect : bool = true
@export_range(0,2) var typewriter_speed : float = 1
@export var allow_gameplay_during : bool = false
@export var next_on_tween_finish : bool = false
