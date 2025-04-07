extends Area3D
class_name damager

var collided_bodies : Array[Node3D] ##a list of every body this has collided with
var damage_to_deal : int = 0 ##the ammount of damage we want to deal
func _ready() -> void:
	print("we spawned a damage bubble")
	pass

func _process(delta: float) -> void:
	pass

func enemy_enter(body : Node3D): ##called whenever the enemy enters the area, add it to the list and deal damage
	print("SOMETHING entered our damage bubble")
	if(!collided_bodies.has(body) and get_npc_controller(body) != null):
		collided_bodies.append(body)
		##do damage here
		var npc : NPC = get_npc_controller(body)
		npc.take_damage(damage_to_deal)
		print("ouch, we damaged: " + body.name)
	else:
		print("we returned : ", get_npc_controller(body))
	##otherwise do nothing

func enemy_exit(body: Node3D): ##called whenever an enemy leaves the area
	##not really worried about this
	pass

func initialize (damage : int): ##set up the bubble so we know how much damage to do
	damage_to_deal = damage
	$damage_life_timer.start()
	print("damage bubble initialized")
	check_all_bodies()

func check_all_bodies():
	var bodies = get_overlapping_bodies()
	print("bodies found: " , bodies.size())
	for b in bodies:
		enemy_enter(b)

func end_damage(): ##when the timer goes off destroy the bubble
	queue_free()

func get_npc_controller(body : Node3D) -> NPC: ##returns the npc controller for a given body
	var current = body
	var found_body : bool = false
	while current:
		if current.is_in_group("npc"):
			print("Found NPC: ", current.name)
			found_body = true
			break
		if current.get_parent() == null:
			print("Reached the root without finding an NPC.")
			break
		current = current.get_parent()
	if found_body:
		return current
	return null
