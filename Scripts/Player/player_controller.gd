extends CharacterBody3D
class_name player

var input : Vector2
@export var anim_tree : AnimationTree
@export var player_model : Node3D
@export var walk_speed : float = 100
var is_walking : bool

func _ready() -> void:
	Autoload.references.set("player",self)
	anim_tree.active = true

func update_input():
	input = Input.get_vector("left","right","down","up")
	is_walking = input != Vector2.ZERO
	anim_tree["parameters/conditions/walk"] = (is_walking)
	anim_tree["parameters/conditions/notWalk"] = (!is_walking)

func _process(delta):
	update_input()
	look_facing(delta)
	update_velocity()

func update_velocity():
	velocity = Vector3(-input.x * walk_speed,0,input.y*walk_speed)
	move_and_slide()

func look_facing(delta : float): ##make the players body face the correct direction
	if input.length() > 0.1:
		var input_vector = input.normalized()
		var move_direction = Vector3(input_vector.x, 0, -input_vector.y)

		# Calculate the target angle based on movement direction
		var target_rotation = atan2(move_direction.x, move_direction.z)

		# Smoothly interpolate the current Y rotation to the target
		var current_rotation = player_model.rotation.y
		var smooth_rotation = lerp_angle(current_rotation, target_rotation, delta * 10.0)

		# Apply the smoothed rotation
		player_model.rotation.y = smooth_rotation
	
