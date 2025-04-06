extends Node
class_name dialog_manager

#signals
signal dialog_started
signal dialog_ended
signal next_line
signal audio_finished

#states
@export var current_state : dialog_base_state
@export var idle : d_idle_state
@export var load_line : d_load_line_state
@export var play_line : d_play_line_state
@export var cleanup : d_cleanup_state

#dialog
var current_convo : conversation
var current_line : dialog_line
@export var audio_advance_sound : audio_player
@export var tick_sound_player : audio_player

#resources
@export var dialog_UI_Scene : PackedScene
var dialog_UI_Instance : Control
var dialog_label : text_label


#parameters
@export var dialog_timer : float = 0
@export var dialog_index : int = 0
@export var state_name : String



func _ready() -> void:
	await get_tree().process_frame
	Autoload.references.set("dialog_manager",self)
	tick_sound_player = $tick_sound_player
	
	idle.init(self)
	load_line.init(self)
	play_line.init(self)
	cleanup.init(self)
	
	current_state = idle
	current_state.enter_state()

func _process(delta: float) -> void:
	if not Autoload.game_paused and current_state!=null:
		current_state.update(delta)

func start_dialog(convo : conversation):
	if current_state == idle:
		if !convo.allow_gameplay_during:
			Autoload.input_paused = true
		current_convo = convo
		dialog_index = 0
		dialog_timer = 0
		current_state.transition(load_line)
		dialog_started.emit()
	#else:
		#print("attempted to start a new dialog conversation with one already running")
