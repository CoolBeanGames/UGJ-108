extends CharacterBody3D
class_name NPC

@export var nav : NavigationAgent3D
@export var model : Node3D
@export var anim : AnimationTree

func _ready() -> void:
	set_target_position(get_random_position(Vector2(-50,50),Vector2(-40,40)))
	nav.max_speed = 1

func _physics_process(delta: float) -> void:
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

func set_target_position(target_position : Vector3):
	target_position.y = 0
	nav.target_position = target_position
	
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
	set_target_position(get_random_position(Vector2(-50,50),Vector2(-40,40)))
	$wait_to_adjust.stop()
