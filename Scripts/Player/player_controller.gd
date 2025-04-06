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

signal attacking

func _ready() -> void:
	Autoload.references.set("player",self)
	anim_tree.active = true
	target_rotation = player_model.rotation.y

func update_input():
	input = Input.get_vector("left","right","down","up")
	is_walking = input != Vector2.ZERO
	anim_tree["parameters/conditions/walk"] = (is_walking)
	anim_tree["parameters/conditions/notWalk"] = (!is_walking)

func _process(delta):
	if !Autoload.input_paused:
		update_input()
		look_facing(delta)
		update_velocity()
		lerp_rot(delta)
		if Input.is_action_just_released("action") and !dont_attack:
			attack()
		if is_attacking and !attack_done and enemy_in_attack_area:
			print("attacked enemy")
			attacking.emit()
			var signal_name = "attacking"
			var connections = get_signal_connection_list(signal_name)
			for conn in connections:
				if conn.has("target") and conn.has("method"):
					var target : Object = conn["target"]
					var method : String= conn["method"]
					if is_connected(signal_name, Callable(target, method)):
						disconnect(signal_name, Callable(target, method))
			print(attacking.get_connections())

func update_velocity():
	velocity = Vector3(-input.x * walk_speed,0,input.y*walk_speed)
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

func end_attack():
	$attack_timer.stop()
	anim_tree["parameters/conditions/not_attack"] = true
	anim_tree["parameters/conditions/attack"] = false
	is_attacking = false
	print(attacking.get_connections().size())


func _on_attack_enter(body: Node3D) -> void:
	enemy_in_attack_area = true
	enemies_in_attack_area += 1
	var current = body
	var found_body : bool = false
	while current:
		if current.is_in_group("npc"):
			print("Found NPC: ", current.name)
			found_body = true
			break
		if current.get_parent() == null:
			print("Reached the root without finding an NPC.")
			break
		current = current.get_parent()
	if found_body:
		print("connecting signal")
		if !attacking.is_connected(current.take_damage):
			attacking.connect(current.take_damage)


func _on_attack_exit(body: Node3D) -> void:
	enemies_in_attack_area -=1
	if enemies_in_attack_area == 0:
		enemy_in_attack_area = false
