extends dialog_base_state
class_name d_cleanup_state

func init(master : dialog_manager):
	super.init(master)

func enter_state():
	var canvas : UI_Canvas = Autoload.references["ui_root"]
	manager.current_convo = null
	manager.current_line = null
	#manager.play_animation(manager.close_Animation)
	manager.dialog_timer = 0
	manager.dialog_index = 0
	Autoload.input_paused=false
	canvas.deactivate_dialog_ui(false)
	manager.dialog_ended.emit()
	transition(manager.idle)
	super.enter_state()

func exit_state():
	manager.dialog_ended.emit()
	super.exit_state()

func transition(next_state : dialog_base_state):
	super.transition(next_state)

func update(delta : float):
	manager.state_name = "cleanup"
	super.update(delta)
