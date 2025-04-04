extends dialog_base_state
class_name d_idle_state

func init(master : dialog_manager):
	super.init(master)

func enter_state():
	super.enter_state()

func exit_state():
	super.exit_state()

func transition(next_state : dialog_base_state):
	super.transition(next_state)

func update(delta : float):
	manager.state_name = "idle"
	super.update(delta)
