extends Control

signal event_resolved

func resolve():
	if Dungeon.current_room.has_key:
		print("You fond a key !")
	else:
		print("You found some random stuff i'll ad later...")
	yield(get_tree().create_timer(1.0), "timeout")	
	emit_signal("event_resolved")
	
func _ready():
	pass
