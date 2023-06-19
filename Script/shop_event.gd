extends Control

signal event_resolved

func resolve():
	print("Oh great a shop spend you money !")
	yield(get_tree().create_timer(1.0), "timeout")	
	emit_signal("event_resolved")
	
func _ready():
	pass
