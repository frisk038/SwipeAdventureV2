extends Control

signal event_resolved

func resolve():
	print("There's a monster hiding but you cant fight it yet.")
	yield(get_tree().create_timer(1.0), "timeout")	
	emit_signal("event_resolved")
	
func _ready():
	pass
