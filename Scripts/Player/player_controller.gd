extends CharacterBody3D
class_name player

var input : Vector2
@export var anim_tree : AnimationTree
@export var player_model : Node3D
@export var walk_speed : float = 100
@export var dont_attack : bool = false
@export var is_attacking : bool = false
@export var enemy_in_attack_area : bool = false
@export var attack_done : bool = false
var is_walking : bool
var target_rotation : float
var enemies_in_attack_area : int = 0
@export var combat_mode : bool = false
@export var damage : int = 1
@export var attack_bubble_spawn_pos : Node3D
@export var damage_bubble_packed_scene : PackedScene

func _ready() -> void:
	Autoload.references.set("player",self)
	anim_tree.active = true
	target_rotation = player_model.rotation.y
	if Autoload.day > 5:
		combat_mode = true

func update_input():
	input = Input.get_vector("left","right","down","up")
	is_walking = input != Vector2.ZERO
	anim_tree["parameters/conditions/walk"] = (is_walking)
	anim_tree["parameters/conditions/notWalk"] = (!is_walking)

func _process(delta):
	if !Autoload.input_paused:
		update_input()
		look_facing(delta)
		update_velocity(delta)
		lerp_rot(delta)
		if Input.is_action_just_released("action") and !dont_attack:
			attack()
		else:
			if Input.is_action_just_released("action"):
				print("could not attack, dont attack is set to: " , dont_attack)

func update_velocity(delta : float):
	velocity = Vector3(-input.x * walk_speed,0,input.y*walk_speed)
	velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * (delta*5)
	move_and_slide()

func look_facing(delta : float): ##make the players body face the correct direction
	if input.length() > 0.1:
		var input_vector = input.normalized()
		var move_direction = Vector3(input_vector.x, 0, -input_vector.y)

		# Calculate the target angle based on movement direction
		target_rotation = atan2(move_direction.x, move_direction.z)	

func lerp_rot(delta : float):
	# Smoothly interpolate the current Y rotation to the target
	var current_rotation = player_model.rotation.y
	var smooth_rotation = lerp_angle(current_rotation, target_rotation, delta * 10.0)

	# Apply the smoothed rotation
	player_model.rotation.y = smooth_rotation

func attack():
	if !is_attacking:
		$attack_timer.start()
		anim_tree["parameters/conditions/not_attack"] = false
		anim_tree["parameters/conditions/attack"] = true
		is_attacking=true
		attack_done=false
		
		var bubble : damager = damage_bubble_packed_scene.instantiate()
		var game_p : Node = Autoload.references["game"]
		game_p.add_child(bubble)
		bubble.global_position = attack_bubble_spawn_pos.global_position
		bubble.initialize(damage)
		
		$player_model/damage_particles.emitting = true

func end_attack():
	print("end attack")
	$attack_timer.stop()
	anim_tree["parameters/conditions/not_attack"] = true
	anim_tree["parameters/conditions/attack"] = false
	is_attacking = false

func _on_attack_enter(body: Node3D) -> void:
	enemy_in_attack_area = true
	enemies_in_attack_area += 1

func _on_attack_exit(body: Node3D) -> void:
	enemies_in_attack_area -=1
	if enemies_in_attack_area == 0:
		enemy_in_attack_area = false
