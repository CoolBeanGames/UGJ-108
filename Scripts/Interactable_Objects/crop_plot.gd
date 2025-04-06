extends interactive_object
class_name crop_plot

@export var crop_stages : Array[Node3D]
@export var crop_key : String = "crop_"
@export var age : int = -1
@export var can_interact : bool = true
@export var particles : GPUParticles3D
@export var light : OmniLight3D
@export var plant_sound : audio_player
@export var water_soudn : audio_player

func _ready() -> void:
	light.visible = false
	particles.emitting = false
	if game_data.data.has(crop_key):
		age = game_data.read_data(crop_key)
	else:
		game_data.store_data(crop_key,age,false)
	var is_watered = false
	if game_data.data.has(crop_key + "watered"):
		is_watered = game_data.read_data(crop_key + "watered")
	#make sure the crop has been planted (age != -1) and we watered it the day before
	if age != -1 and is_watered:
		age += 1
		game_data.store_data(crop_key,age,false)
		game_data.store_data(crop_key + "watered",false,false)
	update_label()
	enable_crops()

func start_looking(_target : Node = null):
	if(can_interact):
		super.start_looking(_target)

func enable_crops():
	if age == 0:
		$crops_cornStageA2.visible = true
		$crops_cornStageB2.visible = false
		$crops_cornStageC2.visible = false
		$crops_cornStageD2.visible = false
	elif age == 1:
		$crops_cornStageA2.visible = false
		$crops_cornStageB2.visible = true
		$crops_cornStageC2.visible = false
		$crops_cornStageD2.visible = false
	elif age == 2:
		$crops_cornStageA2.visible = false
		$crops_cornStageB2.visible = false
		$crops_cornStageC2.visible = true
		$crops_cornStageD2.visible = false
	elif age == 3:
		$crops_cornStageA2.visible = false
		$crops_cornStageB2.visible = false
		$crops_cornStageC2.visible = false
		$crops_cornStageD2.visible = true
	elif age == -1:
		$crops_cornStageA2.visible = false
		$crops_cornStageB2.visible = false
		$crops_cornStageC2.visible = false
		$crops_cornStageD2.visible = false

func _process(delta: float) -> void:
	if age == -1:
		interact_text = "plant seed"
	var is_watered = false
	if game_data.data.has(crop_key + "watered"):
		is_watered = game_data.read_data(crop_key + "watered")
		if !is_watered:
			if age < 3 and age > -1:
				interact_text = "water plant"
	if age == 3:
		interact_text = "harvest plant"

func update_label():
	var is_watered = false
	if age == -1:
		interact_text = "plant seed"
	else:
		if game_data.data.has(crop_key + "watered"):
			is_watered = game_data.read_data(crop_key + "watered")
			if !is_watered:
				if age < 3 and age > -1:
					interact_text = "water plant"
		else:
			game_data.store_data(crop_key + "watered",false,false)
			print("age is " + str(age) + " : " + str(age < 3 and age > -1))
			if age < 3 and age > -1:
					interact_text = "water plant"
		if age == 3:
			interact_text = "harvest plant"

func update_age():
	game_data.store_data(crop_key,age,false)

func water_crop():
	water_soudn.play_sound()
	can_interact=false
	light.visible=true
	particles.emitting=true
	game_data.store_data(crop_key + "watered",true,false)

func is_watered() -> bool:
	if game_data.data.has(crop_key + "watered"):
		return game_data.read_data(crop_key + "watered")
	else:
		return false

func action():
	
	if can_interact:
		if age == -1 and game_data.read_data("seeds") > 0:
			age=0
			plant_sound.play_sound()
			game_data.store_data("seeds",game_data.read_data("seeds") - 1)
			update_age()
		elif age == 0 and !is_watered():
			water_crop()
		elif age == 1 and !is_watered():
			water_crop()
		elif age == 2 and !is_watered():
			water_crop()
		elif age == 3:
			age=2
			game_data.store_data("corn",game_data.read_data("corn") + 1)
			game_data.store_data("seeds",game_data.read_data("seeds") + 1)
			game_data.store_data(crop_key,age,false)
			##add crops here
		update_label()
		enable_crops()
		end_looking()
	super.action()
