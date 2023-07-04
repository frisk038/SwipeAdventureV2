extends Node

const dungeon_height := 6
const dungeon_width := 11
const start_row := 5 
const start_col := 5 
var layout  := []
var rng = null

class Dungeon_Room:
	var name :String
	var type: String
	var rooms :Array = [null, null, null]
	var parent: Dungeon_Room
	var locked: bool
	var has_key: bool
	var level :int
	var has_visited :bool
	var row:int
	var col:int

func _init_array():
	for y in range(dungeon_height):
		var row := []
		for x in range(dungeon_width):
			row.append(null)
		layout.append(row)

func print_layout():
	var rp := '' 
	for r in layout:
		for c in r:
			var p = ''
			if c == null:
				p = '□'
			else:
				p = '■'
			rp += p
		rp += '\n'
	print(rp)

func _get_nb_room(level: int) -> int:
	var x = rng.randf()
	match level:
		1, 2:
			if x <= 0.5:
				return 3
			else:
				return 2
		3:
			if x <= 0.3:
				return 3
			else:
				return 2
		4:
			if x <= 0.1:
				return 3
			elif x>0.1 and x<=0.5 :
				return 2
			else:
				return 0
		5:
			if x <= 0.05:
				return 1
			else:
				return 0
		6:
			return 0
		_: 
			print("err level not implmented")
			return -1

func _get_possible_doors(room:Dungeon_Room) -> Dictionary:
	var left = room.col - 1
	var right = room.col + 1
	var up = room.row - 1
	var left_room = Dungeon_Room.new()
	var up_room = Dungeon_Room.new()
	var right_room = Dungeon_Room.new()
	left_room.row = room.row
	left_room.col = left
	up_room.row = up
	up_room.col = room.col
	right_room.row = room.row
	right_room.col = right
	
	var doors = {0: left_room, 1: up_room, 2: right_room}
	 
	if left < 0 || layout[room.row][left] != null:
		doors.erase(0)
	if up <  0 || layout[up][room.col] != null:
		doors.erase(1)
	if right >= dungeon_width || layout[room.row][right] != null:
		doors.erase(2)
	
	return doors

func _generate_layout(room:Dungeon_Room, level:int):
	var nb_doors := _get_nb_room(level)
	var possible_doors = _get_possible_doors(room)
	
	for i in range(nb_doors):
		if possible_doors.size() == 0 :
			break
		var key = possible_doors.keys()[randi()%possible_doors.size()]
		room.rooms[key] = possible_doors[key]
		layout[possible_doors[key].row][possible_doors[key].col] = room.rooms[key]
		possible_doors.erase(key)
		
	for i in range(room.rooms.size()):
		if room.rooms[i] != null:
			_generate_layout(room.rooms[i], level+1)
#[
#	[Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null], 
#	[Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null], 
#	[Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null], 
#	[Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null], 
#	[Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null], 
#	[Null, Null, Null, Null, Null, STPT, Null, Null, Null, Null, Null]
#]
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	_init_array()
	var r = Dungeon_Room.new()
	r.row = start_row
	r.col = start_col
	layout[start_row][start_col] = r
	
	_generate_layout(layout[start_row][start_col], 1)
	print_layout()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
