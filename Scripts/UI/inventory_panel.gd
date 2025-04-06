extends Panel

var seeds : int = 6
var coins : int = 0
var corn : int = 0

@export var seed_label : text_label
@export var corn_label : text_label
@export var coin_label : text_label

func _process(delta: float) -> void:
	update_data()
	update_labels()

func update_data():
	#update coins
	if game_data.data.has("coins"):
		coins = game_data.read_data("coins")
	else:
		game_data.store_data("coins",coins)
	#update corn
	if game_data.data.has("corn"):
		corn = game_data.read_data("corn")
	else:
		game_data.store_data("corn",corn)
	#update seeds
	if game_data.data.has("seeds"):
		seeds = game_data.read_data("seeds")
	else:
		seeds = 6
		game_data.store_data("seeds",seeds)

func update_labels():
	seed_label.text = "X " + str(seeds) 
	corn_label.text = "X " + str(corn)
	coin_label.text = "X " + str(coins)
