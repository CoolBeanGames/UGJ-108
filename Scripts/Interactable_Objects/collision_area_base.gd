extends Area3D
class_name collision_area

@export var interact_text : String = "use " + name
@export var in_area : bool = false

func _on_body_entered(body: Node3D) -> void:
	in_area = true
	Autoload.references["ui_root"].update_interact(interact_text)

func _process(delta: float) -> void:
	if in_area and Input.is_action_just_released("action"):
		action()

func _on_body_exited(body: Node3D) -> void:
	in_area = false
	Autoload.references["ui_root"].hide_interact()

func action():
	pass
