extends Node3D

func _ready():
	print("running")
	$CSGCylinder3D.visible = false
	Autoload.points_on_interest.append(self)
	print(Autoload.points_on_interest.size())
