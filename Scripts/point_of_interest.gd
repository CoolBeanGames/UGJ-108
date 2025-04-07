extends Node3D

func _ready():
	$CSGCylinder3D.visible = false
	Autoload.points_on_interest.append(self)
