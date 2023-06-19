extends Control

const DETECTION_TRESHOLD = 60

onready var card:Panel = $"card"
onready var back:Panel = $"back"
onready var hint_left = $"card/AnimatedSprite/hint_bg/hint_left"
onready var hint_up = $"card/AnimatedSprite/hint_bg/hint_up"
onready var hint_right = $"card/AnimatedSprite/hint_bg/hint_right"
onready var hint_down = $"card/AnimatedSprite/hint_bg/hint_down"
onready var hint_up_bg = $"card/AnimatedSprite/hint_bg"

var drag_start_pos:Vector2
var is_dragging:bool

signal choice_made

func on_click_release(_evt_position:Vector2):
	print('on_click_release() must be overriden')
	
func show_hint(choice:int):
	hide_hint()
	hint_up_bg.visible = true
	match choice:
		Dungeon.RIGHT:
			hint_right.visible=true
		Dungeon.LEFT:
			hint_left.visible=true
		Dungeon.DOWN:
			hint_down.visible=true
		Dungeon.UP:
			hint_up.visible=true

func hide_hint():
	hint_right.visible = false
	hint_left.visible = false
	hint_down.visible = false
	hint_up.visible = false
	hint_up_bg.modulate.a = 0

func on_clicking(event:InputEventScreenTouch):
	if event.is_pressed() && card.get_rect().has_point(get_local_mouse_position()):
		drag_start_pos = event.position
		is_dragging = true
	elif event.pressed == false && is_dragging:
		is_dragging = false
		on_click_release(event.position)

func on_dragging(evt_position:Vector2):
		var hint_visible_dist = 60
		var pos = (evt_position - drag_start_pos).limit_length(50)
		var choice = vector_to_choice(pos)
		
		card.rect_position = pos
		show_hint(choice)
		var move = pos.y
		if choice == Dungeon.LEFT || choice == Dungeon.RIGHT:
			move = pos.x
		
		card.rect_rotation =  -move * 0.050
		hint_up_bg.modulate = lerp(Color("#00ffffff"), Color("#ffffffff"), 
			abs(move)/hint_visible_dist)

func vector_to_choice(vec:Vector2):
	var absVec = vec.abs()
	if absVec.x > absVec.y:
		if vec.x > 0 :
			return Dungeon.RIGHT
		else:
			return Dungeon.LEFT
	else:
		if vec.y > 0 :
			return Dungeon.DOWN
		else:
			return Dungeon.UP

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventScreenTouch:
		on_clicking(event)
	elif is_dragging && event is InputEventScreenDrag:
		on_dragging(event.position)
