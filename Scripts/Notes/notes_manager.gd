extends Panel
class_name notes_manager

@onready var note_panel : Panel = $"."
@onready var note_text : text_label = $Text_Display_Panel/MarginContainer/text_label
@onready var note_image : TextureRect = $CenterContainer/MarginContainer/TextureRect
@onready var note_text_panel : Panel = $Text_Display_Panel
var canvas : UI_Canvas


@export var note_resource : note_res
@export var is_active : bool = false
@export var note_text_up : bool = false

func _ready() -> void:
	#store references
	Autoload.references.set("note_manager",self)
	Autoload.references.set("note_panel", $".")
	Autoload.references.set("note_image", $CenterContainer/MarginContainer/TextureRect)
	Autoload.references.set("note_text", $Text_Display_Panel/MarginContainer/text_label)
	await get_tree().process_frame
	canvas = Autoload.references["ui_root"]
	deactivate_note(true)

func update_note(res : note_res):
	if is_active:
		print("ERROR: ATTEMPTED TO SHOW A NOTE ON SCREEN WHILE ONE IS ALREADY ACTIVE")
		print("NOTE UPDATE FAILED")
	else:
		note_resource = res
		note_image.texture = note_resource.image
		note_text.text = note_resource.text
		activate_notes()
		Autoload.input_paused = true
		await get_tree().process_frame
		is_active=true

func activate_notes(): ##BRING UP THE BASE FOR THE NOTE UI
	canvas.activate_UI_element(note_panel)
	canvas.activate_UI_element(note_image)

func activate_text(): ##BRING UP THE TEXT PORTION OF THE UI
	canvas.activate_UI_element(note_text)
	canvas.activate_UI_element(note_text_panel)
	note_text_up=true

func deactivate_text(): ##HIDE THE TEXT PORTION OF THE UI
	canvas.deactivate_UI_element(note_text)
	canvas.deactivate_UI_element(note_text_panel)
	note_text_up=false

func deactivate_note(instant : bool = false): ##HIDE ALL 3 ELEMENTS OF THE NOTES UI
	canvas.deactivate_UI_element(note_panel,instant)
	canvas.deactivate_UI_element(note_image,instant)
	canvas.deactivate_UI_element(note_text,instant)
	canvas.deactivate_UI_element(note_text_panel,instant)
	Autoload.input_paused=false
	is_active=false
	note_text_up = false
	note_resource = null

func _process(delta: float) -> void:
	if is_active:
		if Input.is_action_just_released("action"):
			if note_text_up:
				deactivate_text()
			else:
				activate_text()				
		if Input.is_action_just_released("cancel"):
			if note_text_up:
				deactivate_text()
			else:
				deactivate_note()
