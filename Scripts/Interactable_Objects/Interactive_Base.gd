extends Node3D
class_name interactive_object

@export var interact_text : String = " "

func start_looking(_target : Node):
	Autoload.references["ui_root"].update_interact(interact_text)

func end_looking(_target : Node):
	Autoload.references["ui_root"].hide_interact()

func action():
	pass
