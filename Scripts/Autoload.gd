extends Control
class_name auto_load


@export var references : Dictionary[String , Node]
@export var input_paused : bool = false
@export var game_paused : bool = false
@export var current_input_mode : INPUT_MODE
@export var debug_mode : bool = true
@export var day : int = 0
var savedata_path : String
var settings_path : String
@export var points_on_interest : Array[Node3D]

@export var settings : Dictionary

@export var Game_Data : Dictionary

#an enum for the current input mode
enum INPUT_MODE {INPUT_MODE_MOUSE, INPUT_MODE_GAMEPAD}

signal input_mode_changed
signal pause_opened
signal pause_closed

func _ready() -> void:
	#set paths for saving and loading
	var save_path = OS.get_executable_path().get_base_dir().path_join("data")
	DirAccess.make_dir_recursive_absolute(save_path)
	savedata_path = save_path.path_join("save_file.sav")
	settings_path = save_path.path_join("settings.sav")
	#load all gamedata and settings
	load_data(savedata_path,Game_Data)
	initialize_settings()

func _process(_delta: float) -> void:
	if Input.is_action_just_released("quit"):
		get_tree().quit()
	if Input.is_action_just_released("pause"):
		toggle_pause()
	if Input.is_action_just_released("reset_settings") and debug_mode:
		initialize_settings(true)

#toggles the paused and unpaused state
func toggle_pause():
	game_paused = !game_paused
	if game_paused:
		pause_opened.emit()
		if references.has("ui_root"):
			references["ui_root"].pause_sound.play_sound()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		pause_closed.emit()
		save_settings()
		if references.has("ui_root"):
			references["ui_root"].unpause_sound.play_sound()
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	if references.has("pause_screen"):
		references["pause_screen"].visible=game_paused

#changes input mode between gamepad and mouse/keyboard
func change_input_mode(new_mode : INPUT_MODE):
	current_input_mode = new_mode
	input_mode_changed.emit()

#saves current settings to the file
func save_settings():
	save_data(settings_path,settings)

#loads all settings from the file its saved to
func load_settings():
	load_data(settings_path,settings)



#stores a single options value
func store_setting(key : String, value, debug : bool = false):
	settings.set(key,value)

#reads a single option value
func read_setting(key : String, debug : bool = false):
	if settings.has(key):
		return settings[key]
	else:
		return null

#saves all game data to a file
func save_data(path : String, data : Dictionary, append_text : String = ""):
	var file = FileAccess.open(path + append_text,FileAccess.WRITE_READ)
	if file:
		if data.is_empty():
			data.set("data initialized",true)
		var json_string = JSON.stringify(data,"\t")
		var encoded_string = Marshalls.raw_to_base64(json_string.to_utf8_buffer())
		file.store_string(encoded_string)
		file.close()
	#if not FileAccess.file_exists(path):
		#print("failed to create file " + path)

#loads all game data from a file
func load_data(path : String, data : Dictionary, append_text : String = ""):
	if FileAccess.file_exists(path + append_text):
		var file = FileAccess.open(path + append_text,FileAccess.READ)
		if file:
			var encoded_content = file.get_as_text()
			file.close()
			
			var decoded_string = encoded_content.to_utf8_buffer().get_string_from_utf8()
			var content = Marshalls.base64_to_raw(decoded_string).get_string_from_utf8()
			var json = JSON.new()
			var parse_result = json.parse(content)
			if parse_result == OK:
				data.clear()  # Clear existing data to avoid mixing old and new values
				for key in json.data:
					data[key] = json.data[key]  # Copy values properly
			#else:
				#print("could not load game data...")

#initializes settings on first run (or if resetting during debug mode)
func initialize_settings(reset : bool = false):
	if settings.is_empty() and !FileAccess.file_exists(settings_path) or reset:
		store_setting("master_volume",1)
		store_setting("sfx_volume",1)
		store_setting("music_volume",1)
		store_setting("vocal_volume",1)
		store_setting("mouse_sensitivity",1)
		store_setting("gamepad_sensitivity",1)
		store_setting("enable_gamepad",true)
		store_setting("invert_x",false)
		store_setting("invert_y",false)
		save_data(settings_path,settings)
	else:
		load_data(settings_path,settings)
