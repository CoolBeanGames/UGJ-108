extends ShapeCast3D
class_name player_raycast

#objects we are looking at 
var look_at_object : Node = null #the actual object we hit
var target : interactive_object = null #the object that is in the 'raycast_target' group

#nessisary signals
signal stop_looking_at_object(object : Node)
signal start_looking_at_object(object : Node)
signal action_preformed()

#audio players
@export var look_at_sound : audio_player
@export var confirm_sound : audio_player



func _process(_delta: float) -> void:
	if not Autoload.game_paused and not Autoload.input_paused:
		#if we hit anything start processing
		if is_colliding():
			if(look_at_object != get_collider(0)):
				if(target != null):
					stop_looking(target)
					disconnect_signals(target)
				var target_check = get_collider(0)
				
				#loop through to get the objects parent
				while target_check.get_parent():
					if target_check.is_in_group("raycast_target"):
						break
					target_check = target_check.get_parent()
				if not target_check.is_in_group("raycast_target"):
					target_check=null
				else:
					look_at_object = get_collider(0)
					target = target_check
					connect_signals(target)
					#start_looking_sound.play(0)
					start_looking(target)
		else:
			#we hit nothing so clear the data
			if look_at_object != null:
				#stop_looking_sound.play(0)
				stop_looking(target)
				disconnect_signals(target)
				reset()
		
		#action
		if Input.is_action_just_released("action"):
			if target!=null:
				#interact_sound.play(0)
				do_action()

func connect_signals(object_to_connect):
	if not start_looking_at_object.is_connected(object_to_connect.start_looking):
		start_looking_at_object.connect(object_to_connect.start_looking)
	if not stop_looking_at_object.is_connected(object_to_connect.end_looking):
		stop_looking_at_object.connect(object_to_connect.end_looking)
	if not action_preformed.is_connected(object_to_connect.action):
		action_preformed.connect(object_to_connect.action)

func disconnect_signals(object_to_disconnect):
	if(object_to_disconnect):
		if get_signal_connection_list("start_looking_at_object").size() > 0:
			start_looking_at_object.disconnect(object_to_disconnect.start_looking)
		if get_signal_connection_list("stop_looking_at_object").size() > 0:
			stop_looking_at_object.disconnect(object_to_disconnect.end_looking)
		if get_signal_connection_list("action_preformed").size() > 0:
			action_preformed.disconnect(object_to_disconnect.action)

func start_looking(object):
	start_looking_at_object.emit(object)
	if look_at_sound != null:
		look_at_sound.play_sound()
	else:
		print("WARNING: look at sound on player raycaster is null" )

func stop_looking(object):
	stop_looking_at_object.emit(object)

func do_action():
	action_preformed.emit()
	if confirm_sound != null:
		confirm_sound.play_sound()
	else:
		print("WARNING: confirm sound on player raycaster is null" )

func reset():
	look_at_object=null
	target=null
