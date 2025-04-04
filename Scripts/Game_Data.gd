extends Node
class_name GameData ##an Autoload class for saving and loading data

##this class was created by CoolBeanGames for saving and Loading Game Data
##Created for the Three-Six Game Kit, and released for free use by members
##of UGJ
##
##---USAGE---
## add this script to autoload
## use store_data and read_data to access or set any data
##
## save_game_data or load_game_data to save and load
## MAKE SURE savedata_path is SET!


var data : Dictionary = {} ##DO NOT set data to this, use the store and read functions!!!
var savedata_path : String = "save_file.sav" ##Must be set to save game data!!!

func load_game_data(): ##load game data from the save file from savadata_path
	print("loading data")
	load_data(savedata_path,data)
	pass

func save_game_data(): ##save game data to the save file from savedata_path
	save_data(savedata_path,data)
	pass
	
	#stores a single piece of game data
func store_data(key : String, value, store : bool = true): ##store a single value of anytype "value" to the key, "key" and save it to the file if "store" is true
	
	#create the g_data version
	var _data : g_data = g_data.new()
	_data.key = key
	_data.value = value
	_data.store_on_save = store
	
	#store the data
	data.set(key,_data)


func read_data(key : String): ##get data from key, Returns null if data does not exist
	if data.has(key): #check if data exists
		var _data : g_data = data[key] #load the data
		return _data.value #return the value only
	else:
		return null #no data was found so return null

#saves all game data to a file
func save_data(path : String, data : Dictionary, append_text : String = ""): ##saves the game file
	#open the file
	var file = FileAccess.open(path + append_text,FileAccess.WRITE_READ)
	var saveable_data : Dictionary
	
	#convert all data in g_data format to a savable dictionary if store is true
	for d in data.keys():
		var _data : g_data = data[d]
		if _data.store_on_save: #only store if store_on_save is true
			saveable_data.set(d,_data.value)
	
	#check if the file is open
	if file:
		if !data.is_empty():
			#if file is not empty save it
			var json_string = JSON.stringify(saveable_data,"\t") #convert to JSON
			var encoded_string = Marshalls.raw_to_base64(json_string.to_utf8_buffer()) #encode it
			#save the file
			file.store_string(encoded_string)
			file.close()
		else:
			print("could not save file, no save data is present...")
	if not FileAccess.file_exists(path):
		#could not save the file, probably because the path is not valid
		print("failed to create file " + path)


func load_data(path : String, data : Dictionary, append_text : String = ""): ##load data from a save file into memory
	if FileAccess.file_exists(path + append_text):
		#open the file
		var file = FileAccess.open(path + append_text,FileAccess.READ)
		if file:
			#file exists so start processing
			
			#read raw data
			var encoded_content = file.get_as_text()
			file.close()
			
			#start decoding
			var decoded_string = encoded_content.to_utf8_buffer().get_string_from_utf8()
			var content = Marshalls.base64_to_raw(decoded_string).get_string_from_utf8()
			var json = JSON.new()
			var parse_result = json.parse(content)
			if parse_result == OK:
				#data decoded and parsed ok
				data.clear()  # Clear existing data to avoid mixing old and new values
				for key in json.data:
					#loop through and convert to g_data
					var dat = json.data[key]
					var gd : g_data = g_data.new()
					gd.key = key
					gd.value = dat
					gd.store_on_save=true
					data[key] = gd  
			else:
				print("could not load game data...")
