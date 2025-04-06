extends ColorRect
class_name screen_fader

func _ready() -> void:
	Autoload.references.set("screen_fade",self)
	set_progress(1)
	start_tween(0)

func set_progress(progress : float):
	material.set("shader_parameter/progress",progress)

func start_tween(goal : float, is_finish : bool = false):
	var t : Tween = create_tween()
	t.tween_property(material,"shader_parameter/progress",goal,0.5)
	if is_finish:
		t.finished.connect(reload_day)

func reload_day():
	scene_manager.next_day()
