extends Control

signal event_resolved

func resolve():
	print("You're fighyting an elite ! Greater the rsks greater the outcome")
	yield(get_tree().create_timer(1.0), "timeout")	
	emit_signal("event_resolved")
	
func _ready():
	pass
