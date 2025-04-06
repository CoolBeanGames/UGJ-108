extends collision_area
class_name player_house

func _process(delta: float) -> void:
	if in_area:
		if Input.is_action_just_released("action"):
			action()

func action():
	super._on_body_exited(null)
	Autoload.references["screen_fade"].start_tween(1,true)
	super.action()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		super._on_body_entered(body)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		super._on_body_exited(body)
