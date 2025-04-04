extends CanvasLayer
class_name fps_tracker

###this class is for tracking and displaying
###the current fps for the project
###it requires a text_label for displaying

@export var txt : text_label

var frames : int
var fps : int
var counter : float

func _process(delta: float) -> void:
	if txt != null:
		counter+=delta
		frames+=1
		if counter >= 1:
			counter-=1
			fps=frames
			frames=0
		txt.text = str(fps)
