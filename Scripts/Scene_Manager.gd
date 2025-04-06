extends Node
class_name SceneManager

@export var root_scene : Node
@export var loaded_scene : Node
@export var loading_screen : PackedScene
@export var loading_screen_instance : Node
@export var UI_Scene : Control

func _ready() -> void:
	await get_tree().process_frame
	root_scene = get_tree().root.get_child(2) #adjust this for auto_loads...
	loading_screen = load("res://Scenes/UI/loading_scene.tscn")
	#code for testing only
	load_scene(load("res://Scenes/game_map.tscn"),true,load("res://Scenes/UI/ui_canvas.tscn"))

#removes the current scene
func clear_scene():
	loaded_scene.queue_free()

func next_day(): ##this will need updated to show the transition
	Autoload.points_on_interest.clear()
	load_scene(load("res://Scenes/game_map.tscn"),true,load("res://Scenes/UI/ui_canvas.tscn"))
	Autoload.day += 1

#load in a given scene
#if set_instance is true, this is considered the main scene, and is 
#set in the parameters
func spawn_scene(scene_to_load : PackedScene, set_instance : bool = true):
	var scn = scene_to_load.instantiate()
	if set_instance:
		loaded_scene = scn
	root_scene.add_child(scn)
	return scn

#actually loads in a scene, this is what you want to call to actually do one
func load_scene(scene_to_load : PackedScene, use_ui : bool = true, ui_scene : PackedScene = null):
	if loaded_scene:
		clear_scene()
	loading_screen_instance=spawn_scene(loading_screen,false)
	spawn_scene(scene_to_load)
	if use_ui:
		spawn_scene(ui_scene,false)
	loading_screen_instance.queue_free()
