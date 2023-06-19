extends Control

signal event_resolved

func resolve():
	print("Its a peaceful room, take a nap")
	yield(get_tree().create_timer(1.0), "timeout")	
	emit_signal("event_resolved")
	
func _ready():
	pass
