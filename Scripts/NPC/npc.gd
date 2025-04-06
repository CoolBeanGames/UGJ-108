extends CharacterBody3D
class_name NPC

@export var npc_name : String = ""
@export var nav : NavigationAgent3D
@export var model : Node3D
@export var anim : AnimationTree
@export var dialog_mode : bool = false
@export var player_in_bounds : bool = false

@export var day_1_dialog : Array[conversation]
@export var day_2_dialog : Array[conversation]
@export var day_3_dialog : Array[conversation]
@export var day_4_dialog : Array[conversation]
@export var day_5_dialog : Array[conversation]

func _ready() -> void:
	set_target_position()
	nav.max_speed = 1
	anim.active = true

func _process(delta: float) -> void:
	if Input.is_action_just_released("action") and !dialog_mode and player_in_bounds:
		if Autoload.input_paused == false:
			action()

func _physics_process(delta: float) -> void:
	if !dialog_mode:
		if nav.is_navigation_finished():
			anim["parameters/conditions/notWalk"] = true
			anim["parameters/conditions/walk"] = false
			return
		else:
			anim["parameters/conditions/notWalk"] = false
			anim["parameters/conditions/walk"] = true
		
		var next_path_position = nav.get_next_path_position()
		var direction = (next_path_position - global_transform.origin).normalized()
		rot(direction,delta)
		velocity = direction * nav.max_speed
		velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
		nav.velocity = velocity
		move_and_slide()
	else:
		look_at_player()

func set_target_position():
	await get_tree().process_frame
	var random : RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = Time.get_datetime_dict_from_system().second * 10101 / 15
	var position : Vector3 = Autoload.points_on_interest[random.randi_range(0,Autoload.points_on_interest.size()-1)].position
	nav.target_position = position

func get_random_position(min_max_x : Vector2, min_max_z : Vector2) -> Vector3:
	var ran : RandomNumberGenerator = RandomNumberGenerator.new()
	return Vector3(ran.randf_range(min_max_x.x,min_max_x.y),0,ran.randf_range(min_max_z.x,min_max_z.y))

func rot(move_direction : Vector3, delta : float):
	# Calculate the target angle based on movement direction
		var target_rotation = atan2(move_direction.x, move_direction.z)

		# Smoothly interpolate the current Y rotation to the target
		var current_rotation = model.rotation.y
		var smooth_rotation = lerp_angle(current_rotation, target_rotation, delta * 10.0)

		# Apply the smoothed rotation
		model.rotation.y = smooth_rotation

func _on_navigation_agent_3d_navigation_finished() -> void:
	$wait_to_adjust.start()

func _on_wait_to_adjust_timeout() -> void:
	set_target_position()
	$wait_to_adjust.stop()

func start_conversation():
	var player = Autoload.references["player"]
	look_at(player.position)
	dialog_mode=true

func look_at_player():
	var player = Autoload.references["player"]
	var direction = (player.global_position - global_position).normalized()
	var target_rotation = atan2(direction.x, direction.z)
	var current_rotation = model.rotation.y
	var smooth_rotation = lerp_angle(current_rotation, target_rotation, get_process_delta_time() * 10.0)
	model.rotation.y = smooth_rotation

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_bounds = true
		Autoload.references["player"].dont_attack = true
		Autoload.references["ui_root"].update_interact("Talk to " + npc_name)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_bounds = false
		Autoload.references["player"].dont_attack = false
		Autoload.references["ui_root"].hide_interact()

func action():
	Autoload.input_paused = true
	dialog_mode=true
	var dialogmanager : dialog_manager = Autoload.references["dialog_manager"]
	dialogmanager.dialog_ended.connect(dialog_done)
	nav.target_position = global_position
	
	#choose a dialog
	var convo : conversation
	var day : int = Autoload.day + 1
	if day == 1:
		convo = day_1_dialog[0]
		if day_1_dialog.size() > 1:
			day_1_dialog.remove_at(0)
	if day == 2:
		convo = day_2_dialog[0]
		if day_2_dialog.size() > 1:
			day_2_dialog.remove_at(0)
	if day == 3:
		convo = day_3_dialog[0]
		if day_3_dialog.size() > 1:
			day_4_dialog.remove_at(0)
	if day == 4:
		convo = day_4_dialog[0]
		if day_4_dialog.size() > 1:
			day_4_dialog.remove_at(0)
	if day == 5:
		convo = day_5_dialog[0]
		if day_5_dialog.size() > 1:
			day_5_dialog.remove_at(0)
	if convo!=null:
		print("we should be starting a dialog")
		dialogmanager.start_dialog(convo)

func dialog_done():
	var dialogmanager : dialog_manager = Autoload.references["dialog_manager"]
	dialogmanager.dialog_ended.disconnect(dialog_done)
	dialog_mode = false
	set_target_position()

func take_damage():
	print("ouch!")
