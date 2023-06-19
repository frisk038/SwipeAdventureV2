extends Control

onready var left_text = $"card_control/card/AnimatedSprite/hint_bg/hint_left"
onready var up_text = $"card_control/card/AnimatedSprite/hint_bg/hint_up"
onready var right_text = $"card_control/card/AnimatedSprite/hint_bg/hint_right"
onready var down_text = $"card_control/card/AnimatedSprite/hint_bg/hint_down"
onready var img_card = $"card_control/card/AnimatedSprite"
onready var life_point = $"stat_bg/HBoxContainer/life/life_point"
onready var food_point = $"stat_bg/HBoxContainer/food/food_point"
onready var money_point = $"stat_bg/HBoxContainer/money/money_point"
onready var location = $"card_control/card/location"
onready var card = $"card_control"
onready var inventory = $"bag"

func update():
	img_card.frames.clear("default")
	
	if Dungeon.current_room.rooms[Dungeon.LEFT]:
		left_text.bbcode_text = "[center]LEFT[/center]" 
	else:
		left_text.bbcode_text = "[center]DEAD END[/center]"

	if Dungeon.current_room.rooms[Dungeon.RIGHT]:
		right_text.bbcode_text = "[center]RIGHT[/center]" 
	else:
		right_text.bbcode_text = "[center]DEAD END[/center]"

	if Dungeon.current_room.rooms[Dungeon.UP]:
		up_text.bbcode_text = "[center]UP[/center]" 
	else:
		up_text.bbcode_text = "[center]DEAD END[/center]"

	down_text.bbcode_text = "[center]BACK[/center]" 

#
#	location.text = Dungeon.current_room.type + "/" + Dungeon.current_room.name
	card.call("reveal_next_card")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_card_control_choice_made(direction):
	if visible:
		Dungeon.set_current_room(direction)
