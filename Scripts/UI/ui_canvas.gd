extends CanvasLayer
class_name UI_Canvas

#references for parts of the UI
@export var Interact_Text : text_label
@export var Dialog_Text : text_label
@onready var Dialog_Panel : Control = $"Dialog Panel"
@onready var dialog_button : Control = $"Dialog Panel/interact_button"
@onready var pause_button_panel : Control = $pause_button_panel
@onready var quit_button_panel : Control = $quit_button_panel
@onready var options_panel : Control = $Pause_Menu/Options_Panel

#button textures
@export var button_texture : TextureRect
@export var dialog_button_texture : TextureRect
@onready var quit_button_texture : TextureRect = $quit_button_panel/HBoxContainer/button
@onready var pause_button_texture : TextureRect = $pause_button_panel/HBoxContainer/button

#sound player for ui
@onready var pause_sound : audio_player = $pause_sound
@onready var unpause_sound : audio_player = $unpause_sound

#load in the options ui elements
@onready var master_slider : HSlider = $Pause_Menu/Options_Panel/inner_panel/VBoxContainer/Master_Volume/HBoxContainer/Master_Volume_Slider
@onready var sfx_slider : HSlider = $Pause_Menu/Options_Panel/inner_panel/VBoxContainer/SFX_Volume/HBoxContainer/Master_Volume_Slider
@onready var music_slider : HSlider = $Pause_Menu/Options_Panel/inner_panel/VBoxContainer/Music_Volume/HBoxContainer/Master_Volume_Slider
@onready var vocal_slider : HSlider = $Pause_Menu/Options_Panel/inner_panel/VBoxContainer/Vocals_Volume/HBoxContainer/Master_Volume_Slider
@onready var mouse_sensitivity_slider : HSlider =$Pause_Menu/Options_Panel/inner_panel/VBoxContainer/Mouse_Sensitivity/HBoxContainer/Master_Volume_Slider
@onready var gamepad_sensitivity_slider : HSlider =$Pause_Menu/Options_Panel/inner_panel/VBoxContainer/Gamepad_Sensitivity/HBoxContainer/Master_Volume_Slider
@onready var enable_gamepad : CheckBox = $Pause_Menu/Options_Panel/inner_panel/VBoxContainer/Enable_Gamepad/HBoxContainer/enable_gamepad_check
@onready var invert_x : CheckBox = $"Pause_Menu/Options_Panel/inner_panel/VBoxContainer/Invert X/HBoxContainer/invert_x_check"
@onready var invert_y : CheckBox = $"Pause_Menu/Options_Panel/inner_panel/VBoxContainer/Invert Y/HBoxContainer/invert_y_check"

@export var options_opened : bool = false

signal interact_text_changed
signal interact_text_begin_showing
signal interact_text_stop_showing

signal dialog_text_changed
signal dialog_text_begin_showing
signal dialog_text_stop_showing

#button resources
var keys : Dictionary[String,CompressedTexture2D]

func _ready() -> void:
	Autoload.references.set("ui_root",self)
	_load_ui_keys()
	Autoload.input_mode_changed.connect(_update_button_image)
	Autoload.input_mode_changed.connect(_update_quit_and_pause_button)
	_update_button_image()
	_update_quit_and_pause_button()
	Autoload.pause_opened.connect(update_options_settings)
	Autoload.pause_closed.connect(store_option_settings)
	Autoload.references.set("pause_screen" ,$Pause_Menu)
	
	#dialog references
	Autoload.references.set("dialog_panel",$"Dialog Panel" )
	Autoload.references.set("dialog_text",$"Dialog Panel/Dialog Text" )
	Autoload.references.set("dialog_button",$"Dialog Panel/interact_button" )
	Autoload.references.set("dialog_name_panel",$"Dialog Panel/Dialog Name Panel" )
	Autoload.references.set("dialog_name_text",$"Dialog Panel/Dialog Name Panel/Name")
	
	#interaction references
	Autoload.references.set("interact_panel",$"Tooltip Panel")
	Autoload.references.set("interact_text",$"Tooltip Panel/MarginContainer/Interact Text")
	Autoload.references.set("interact_button",$"Tooltip Panel/interact_button")
	deactivate_dialog_ui(true)
	deactivate_interact_panel(true)

func deactivate_interact_panel(instant : bool = false): ##turns off the whole interaction UI
	deactivate_UI_element($"Tooltip Panel",instant)
	deactivate_UI_element($"Tooltip Panel/MarginContainer/Interact Text",instant)
	deactivate_UI_element($"Tooltip Panel/interact_button",instant)
 
func deactivate_dialog_ui(instant : bool = false): ##turns off the whole dialog UI
	deactivate_UI_element($"Dialog Panel",instant)
	deactivate_UI_element($"Dialog Panel/Dialog Text",instant)
	deactivate_UI_element($"Dialog Panel/interact_button",instant)
	deactivate_UI_element($"Dialog Panel/Dialog Name Panel",instant)
	deactivate_UI_element($"Dialog Panel/Dialog Name Panel/Name",instant)
	deactivate_UI_element($"Tooltip Panel",instant)

#load in all of the textures for the on screen ui controls
func _load_ui_keys():
	keys.set("e_key",load("res://textures/UI/Button_Prompts/keyboard_e_outline.png"))
	keys.set("a_button", load("res://textures/UI/Button_Prompts/xbox_button_color_a.png"))
	keys.set("esc_key",load("res://textures/UI/Button_Prompts/keyboard_escape.png"))
	keys.set("f12_key",load("res://textures/UI/Button_Prompts/keyboard_f12.png"))
	keys.set("start_button",load("res://textures/UI/Button_Prompts/xbox_button_start.png"))
	keys.set("back_button", load("res://textures/UI/Button_Prompts/xbox_button_back_icon.png"))

#update the interaction text
func update_interact(text : String):
	#update our references
	var canvas : UI_Canvas = Autoload.references["ui_root"]
	var interact_panel : Control = Autoload.references["interact_panel"]
	var interact_text : text_label = Autoload.references["interact_text"]
	var interact_button : Control = Autoload.references["interact_button"]
	
	#enable our stuff
	if interact_panel.self_modulate != Color.WHITE:
		interact_text_begin_showing.emit()
		activate_UI_element(interact_panel)
		activate_UI_element(interact_text)
		activate_UI_element(interact_button)
	
	#emit signal if it was just changed
	if interact_text.text != text:
		interact_text_changed.emit()
	
	#set the text
	interact_text.text = text

#hide the interaction panel
func hide_interact():
	deactivate_interact_panel()

#hide the dialog display
func hide_dialog():
	deactivate_dialog_ui()

func _update_button_image():
	if Autoload.current_input_mode == Autoload.INPUT_MODE.INPUT_MODE_MOUSE:
		button_texture.texture = keys["e_key"]
		dialog_button_texture.texture = keys["e_key"]
	else:
		button_texture.texture = keys["a_button"]
		dialog_button_texture.texture = keys["a_button"]

func _update_quit_and_pause_button():
	if not Autoload.debug_mode:
		pause_button_panel.visible = false
		quit_button_panel.visible = false
	else:
		if Autoload.current_input_mode == Autoload.INPUT_MODE.INPUT_MODE_MOUSE:
			pause_button_texture.texture = keys["esc_key"]
			quit_button_texture.texture = keys["f12_key"]
		else:
			pause_button_texture.texture = keys["start_button"]
			quit_button_texture.texture = keys["back_button"]

#updates the ui elements to reflect the settings
func update_options_settings(param = null):
	master_slider.value = Autoload.read_setting("master_volume",false)
	sfx_slider.value = Autoload.read_setting("sfx_volume",false)
	music_slider.value = Autoload.read_setting("music_volume",false)
	vocal_slider.value = Autoload.read_setting("vocal_volume",false)
	mouse_sensitivity_slider.value = Autoload.read_setting("mouse_sensitivity",false)
	enable_gamepad.button_pressed = Autoload.read_setting("enable_gamepad",false)
	gamepad_sensitivity_slider.value = Autoload.read_setting("gamepad_sensitivity",true) 
	invert_y.button_pressed = Autoload.read_setting("invert_y",true)
	invert_x.button_pressed = Autoload.read_setting("invert_x",true)

#stores the ui elements values in the settings
func store_option_settings(param = null):
	Autoload.store_setting("master_volume",master_slider.value,true)
	Autoload.store_setting("sfx_volume", sfx_slider.value,true)
	Autoload.store_setting("music_volume", music_slider.value,true)
	Autoload.store_setting("vocal_volume",vocal_slider.value,true)
	Autoload.store_setting("mouse_sensitivity", mouse_sensitivity_slider.value,true)
	Autoload.store_setting("enable_gamepad", enable_gamepad.button_pressed,true)
	Autoload.store_setting("gamepad_sensitivity", gamepad_sensitivity_slider.value,true)
	Autoload.store_setting("invert_y",  invert_y.button_pressed,true)
	Autoload.store_setting("invert_x", invert_x.button_pressed,true)

#toggles the options panel on or off
func toggle_options():
	options_opened = !options_opened
	if options_opened:
		activate_UI_element($Pause_Menu/Options_Panel)
	else:
		deactivate_UI_element($Pause_Menu/Options_Panel)

#quit the whole game
func quit():
	get_tree().quit()

#force unpause the game
func resume():
	Autoload.toggle_pause()

func activate_UI_element(con : Control , instant : bool = false, is_clickable : bool = false): ##shows a UI element either instantly, or over time if instant is false
	if instant:
		con.self_modulate = Color.WHITE
		if is_clickable:
			activate_control(con)
	else:
		var tween : Tween = create_tween()
		tween.tween_property(con,"self_modulate",Color(1,1,1,1),.2)
		if is_clickable:
			activate_control(con)

func deactivate_UI_element(con : Control , instant : bool = false): ##hides a UI element either instantly, or over time if instant is false
	if instant:
		con.self_modulate = Color(1,1,1,0)
		deactivate_control(con)
	else:
		var tween : Tween = create_tween()
		tween.tween_property(con,"self_modulate",Color(1,1,1,0),.2)
		deactivate_control(con)

func activate_control(con : Control): ##turns on mouse controls for a single UI element
	con.mouse_filter = Control.MOUSE_FILTER_STOP

func deactivate_control(con : Control): ##turns off mouse controls for a single UI element
	con.mouse_filter = Control.MOUSE_FILTER_IGNORE
