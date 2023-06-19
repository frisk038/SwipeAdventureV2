extends Node

const LEFT = 0
const UP = 1
const RIGHT = 2
const DOWN = 3
const NONE = -1

signal new_path

var game_path:Dictionary

class PathNode:
	var img_res
	var desc_text=""
	var paths=[0,0,0,0]
	var special=""
	var life=0
	var atk=0
	var vname=""
	var left_txt=""
	var up_txt=""
	var right_txt=""
	var down_txt=""
	var location=""

	func _init(a, d, p, s, l, k, n, lt, ut, rt, dt, loc):
		img_res = a
		desc_text = d
		paths = p
		special = s
		life = l
		atk = k
		vname = n
		left_txt = lt
		up_txt = ut
		right_txt = rt
		down_txt = dt
		location = loc


func path_to_string(path:int)-> String:
	match path:
		LEFT:
			return "left"
		UP:
			return "up"
		RIGHT:
			return "right"
		DOWN:
			return "down"
		_:
			return ""

func set_card(card):
	emit_signal("new_path")
	
func _ready():
	pass

