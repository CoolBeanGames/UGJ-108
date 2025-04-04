extends Node
class_name game

func _ready() -> void: ##used to set the reference for instancing stuff
	Autoload.references.set("game",self)
