extends Control

signal event_resolved

func resolve():
	print("Its a peaceful room, take a nap")
	emit_signal("event_resolved")
	
func _ready():
	pass
