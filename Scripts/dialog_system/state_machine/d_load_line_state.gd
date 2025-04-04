extends dialog_base_state
class_name d_load_line_state

func init(master : dialog_manager):
	super.init(master)

func enter_state():
	#print("convo lines size: " + str(manager.current_convo.lines.size()) + " | index: " + str(manager.dialog_index ))
	if manager.current_convo.lines.size() <= manager.dialog_index:
		transition(manager.cleanup)
	else:
		manager.current_line = manager.current_convo.lines[manager.dialog_index]
		manager.dialog_index += 1
		update_dialog_text()
		transition(manager.play_line)
		manager.next_line.emit()
	super.enter_state()

func exit_state():
	super.exit_state()

func transition(next_state : dialog_base_state):
	super.transition(next_state)

func update(delta : float):
	manager.state_name = "load"
	super.update(delta)

func update_dialog_text(): ##setup the dialog box to display text and any other relevant data
	#setting up the dialog text
	print("update dialog text")
	#get references to all of the parts of the dialog panel
	var dialog_panel : Control = Autoload.references["dialog_panel"]
	var dialog_text : text_label = Autoload.references["dialog_text"]
	var dialog_name_panel : Control = Autoload.references["dialog_name_panel"]
	var dialog_name_text : Control = Autoload.references["dialog_name_text"]
	var canvas : UI_Canvas = Autoload.references["ui_root"]
	
	canvas.deactivate_interact_panel()
	
	if !manager.current_line.is_thought:
		print("we are not a thought, so showing panel")
		canvas.activate_UI_element(dialog_panel)
		if manager.current_line.speaker == "":
			print("we do NOT have a speaker")
			canvas.deactivate_UI_element(dialog_name_panel)
			canvas.deactivate_UI_element(dialog_name_text)
			dialog_name_text.text = ""
		else:
			print("we DO have a speaker")
			canvas.activate_UI_element(dialog_name_panel)
			canvas.activate_UI_element(dialog_name_text)
			dialog_name_text.text = manager.current_line.speaker
			canvas.activate_UI_element(dialog_name_panel)
			canvas.activate_UI_element(dialog_name_text)
	else:
		print("this is a thought, so we dont have a speaker or a dialog panel")
		canvas.deactivate_UI_element(dialog_name_panel,true)
		
	canvas.activate_UI_element(dialog_text,true)
	dialog_text.text = manager.current_line.line
