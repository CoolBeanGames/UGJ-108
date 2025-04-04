extends Node
class_name dialog_base_state

var manager : dialog_manager

func init(master : dialog_manager):
	manager = master
	pass

func enter_state():
	pass

func exit_state():
	pass

func transition(next_state : dialog_base_state):
	if self != next_state:
		await get_tree().process_frame
		exit_state()
		next_state.enter_state()
		manager.current_state = next_state
	pass

func update(_delta : float):
	pass
