extends dialog_base_state
class_name d_play_line_state

var current_line : dialog_line
var audio_timer : float
var timing_alarm : Timer
var tween_tick_alarm : Timer
var tick_sound_player : audio_player
var tween_complete : bool = true

func init(master : dialog_manager):
	super.init(master)

func enter_state():
	var canvas : UI_Canvas = Autoload.references["ui_root"]
	var interact_button : Control = canvas.get_child(1)
	if manager.current_line.wait_for_confirm:
		interact_button.visible=true
	else:
		interact_button.visible=false
	if manager.current_convo.typerwriter_effect:
		tween_complete=false
		#setup the typewriter effect
		var text : text_label = Autoload.references["dialog_text"]
		var tween : Tween = create_tween()
		var tween_rate = .02 * manager.current_convo.typewriter_speed * manager.current_line.line.length()
		tween.tween_property(text,"visible_ratio",1.0,tween_rate).from(0.0)
		tween.finished.connect(tween_finished)
		tween_tick_alarm = Timer.new()
		tween_tick_alarm.wait_time = 0.02
		get_tree().root.add_child(tween_tick_alarm)
		play_tick_sound()
		tween_tick_alarm.timeout.connect(play_tick_sound)
	if manager.current_line is voiced_line:
		var a_line : voiced_line = manager.current_line
		a_line.init()
		manager.audio_player.play(0)
	current_line = manager.current_line 
	super.enter_state()

func tween_finished():
	if manager.current_convo.next_on_tween_finish and !manager.current_line.wait_for_confirm:
		timing_alarm = Timer.new()
		get_tree().root.add_child(timing_alarm)
		timing_alarm.wait_time = 1.25
		timing_alarm.timeout.connect(tween_timer_finished)
		timing_alarm.start()
	manager.tick_sound_player.stop()
	tween_tick_alarm.stop()
	tween_complete=true


func play_tick_sound():
	manager.tick_sound_player.play(0)
	tween_tick_alarm.start()

func tween_timer_finished():
	timing_alarm.queue_free()
	timing_alarm=null
	transition(manager.load_line)	

func exit_state():
	super.exit_state()

func transition(next_state : dialog_base_state):
	super.transition(next_state)

func update(delta : float):
	Autoload.references["ui_root"].dialog_button_texture.visible = current_line.wait_for_confirm
	#await get_tree().process_frame
	if current_line.timed_line:
		manager.dialog_timer += delta
		if manager.dialog_timer > current_line.time:
			manager.audio_advance_sound.play_sound()
			transition(manager.load_line)
	if current_line.wait_for_confirm and tween_complete:
		if Input.is_action_just_released("action"):
			manager.audio_advance_sound.play_sound()
			transition(manager.load_line)
	if current_line is voiced_line:
		if current_line.end_after_audio:
			audio_timer += delta
			if audio_timer >= current_line.audio_length + 0.5:
				manager.audio_finished.emit()
				transition(manager.load_line)
	manager.state_name = "play"
	super.update(delta)
