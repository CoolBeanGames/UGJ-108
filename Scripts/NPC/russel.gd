extends NPC

func _ready() -> void:
	await get_tree().process_frame
	super._ready()
	var playback: AnimationNodeStateMachinePlayback = anim.get("parameters/playback")
	playback.start("idle") # or whatever your default state is
