extends Node

class Dungeon_Room:
	var name :String
	var type: String
	var rooms :Array = [null, null, null]
	var parent: Dungeon_Room
	var locked: bool
	var has_key: bool
	var level :int
	var has_visited :bool
	
	func _init(p, nm, lv):
		self.name = nm
		self.parent = p
		self.level = lv
		
	func serialize(indent:String, is_last:bool) -> void:
		var printStr = indent
		if is_last:
			printStr += "\\-"
			indent += "  "
		else :
			printStr += "|-"
			indent += "| "
		printStr += self.name + '|' + self.type + '| lock:' + str(self.locked) + '| key:' + str(self.has_key)
		
		var nb_child = 0
		for i in rooms.size(): 
			if self.rooms[i] != null :
				nb_child = nb_child +1
		if nb_child == 0:
			printStr += "]"
			
		print(printStr)
		for i in rooms.size():
			if self.rooms[i] == null :
				continue
			self.rooms[i].serialize(indent, i==2)

func get_nb_room(level: int) -> int:
	var x = rng.randf()
	match level:
		1, 2:
			if x <= 0.5:
				return 3
			else:
				return 2
#		2:
#			if x <= 0.1:
#				return 0
#			elif x > 0.1 and x <= 0.3:
#				return 3
#			else:
#				return 2
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

func gen_room(room:Dungeon_Room, level:int):
	var nb_door = get_nb_room(level) 
	var doors = [0, 1, 2]
	for i in range(nb_door):
		var d = rng.randi_range(0, doors.size()-1)
		room.rooms[doors[d]] = Dungeon_Room.new(room, str(level)+str(nb_door)+str(i), level)
		sorted_room[level].append(room.rooms[doors[d]])
		doors.erase(d)
	for i in range(room.rooms.size()):
		if room.rooms[i] != null:
			gen_room(room.rooms[i], level+1)

func get_room_type(level:int) -> String:
	var x = rng.randf()
	match level:
		1, 2:
			if x <= 0.6:
				return "Event"
			else:
				return RM_TYPE_FIGHT
		3, 4, 5:
			if x <= 0.2:
				return "Event"
			else:
				return RM_TYPE_FIGHT
		6:
			if x <= 0.1:
				return "Event"
			else:
				return RM_TYPE_FIGHT
		_:
			return ""

func get_room_type2(level:int) -> String:
	var x = rng.randf()
	match level:
		1, 2, 3:
			if x <= 0.1:
				return RM_TYPE_CHEST
			elif x > 0.1 and x <= 0.2:
				return RM_TYPE_REST
			elif x > 0.2 and x <= 0.3:
				return RM_TYPE_TRAP
			elif x > 0.3 and x <= 0.5:
				return RM_TYPE_SHOP
			else:
				return RM_TYPE_FIGHT
		4, 5:
			if x <= 0.1:
				return RM_TYPE_REST
			elif x > 0.1 and x <= 0.2:
				return RM_TYPE_SHOP
			elif x > 0.2 and x <= 0.3:
				return RM_TYPE_TRAP
			elif x > 0.3 and x <= 0.65:
				return RM_TYPE_CHEST
			else:
				return RM_TYPE_FIGHT
		6:
			if x <= 0.3:
				return RM_TYPE_ELITE
			elif x > 0.3 and x <= 0.6:
				return RM_TYPE_CHEST
			else:
				return RM_TYPE_FIGHT
		_:
			return ""

func pop_dungeon():
	for i in sorted_room:
		var rooms = sorted_room[i]
		for r in rooms:
			r.type = get_room_type(r.level)
			if r.type == "Event":
				event_room[r.level].append(r)

func pop_event():
	var has_lock = true
	var has_shop = false
	var has_rest = false
	var chest_room = {1:[],2:[],3:[],4:[],5:[],6:[]}
	
	for r1 in event_room[1]:
		var x = rng.randf()
		if x <= 0.25:
			r1.type = RM_TYPE_CHEST
			chest_room[1].append(r1)
		elif x > 0.25 and x <= 0.5:
			if has_shop:
				r1.type = RM_TYPE_FIGHT
			else:
				r1.type = RM_TYPE_SHOP
				has_shop = true
		elif x > 0.5 and x <= 0.75:
			if has_rest:
				r1.type = RM_TYPE_FIGHT
			else:
				r1.type = RM_TYPE_REST
				has_rest = true
		elif x > 0.75:
			r1.type = RM_TYPE_TRAP
			
	for r1 in event_room[2]:
		var x = rng.randf()
		if x <= 0.25:
			r1.type = RM_TYPE_CHEST
			chest_room[2].append(r1)
		elif x > 0.25 and x <= 0.5:
			if has_shop:
				r1.type = RM_TYPE_FIGHT
			else:
				r1.type = RM_TYPE_SHOP
				has_shop = true
		elif x > 0.5 and x <= 0.75:
			if has_rest:
				r1.type = RM_TYPE_FIGHT
			else:
				r1.type = RM_TYPE_REST
				has_rest = true
		elif x > 0.75:
			r1.type = RM_TYPE_TRAP
	
	for r1 in event_room[3]:
		var x = rng.randf()
		if x <= 0.25:
			r1.type = RM_TYPE_CHEST
			chest_room[3].append(r1)
		elif x > 0.25 and x <= 0.5:
			if has_shop:
				r1.type = RM_TYPE_FIGHT
			else:
				r1.type = RM_TYPE_SHOP
				has_shop = true
		elif x > 0.5 and x <= 0.75:
			if has_rest:
				r1.type = RM_TYPE_FIGHT
			else:
				r1.type = RM_TYPE_REST
				has_rest = true
		elif x > 0.75:
			r1.type = RM_TYPE_TRAP

	for r1 in event_room[4]:
		var x = rng.randf()
		if x <= 0.45:
			r1.type = RM_TYPE_CHEST
			chest_room[4].append(r1)
		elif x > 0.45:
			r1.type = RM_TYPE_TRAP

	for r1 in event_room[5]:
		var x = rng.randf()
		if x <= 0.25:
			r1.type = RM_TYPE_CHEST
		elif x > 0.25:
			r1.type = RM_TYPE_ELITE

	for r1 in event_room[6]:
		r1.type = RM_TYPE_ELITE
	

	if sorted_room[6].size() > 0:
		sorted_room[6][rng.randi() % sorted_room[6].size()].locked = true
	elif sorted_room[5].size() > 0:
		sorted_room[5][rng.randi() % sorted_room[5].size()].locked = true
	else:
		has_lock = false

	if has_lock:
		if chest_room[1].size() > 0:
			chest_room[1][rng.randi() % chest_room[1].size()].has_key = true
		elif chest_room[2].size() > 0:
			chest_room[2][rng.randi() % chest_room[2].size()].has_key = true
		elif chest_room[3].size() > 0:
			chest_room[3][rng.randi() % chest_room[3].size()].has_key = true
		elif chest_room[4].size() > 0:
			chest_room[4][rng.randi() % chest_room[4].size()].has_key = true
		elif chest_room[5].size() > 0:
			chest_room[5][rng.randi() % chest_room[5].size()].has_key = true
		
func gen_dungeon():
	gen_room(dungeon, 1)
	pop_dungeon()
	pop_event()
	
var rng = null
var dungeon = null
var sorted_room = {1:[],2:[],3:[],4:[],5:[],6:[]}
var event_room = {1:[],2:[],3:[],4:[],5:[],6:[]}

func _ready():
	rng = RandomNumberGenerator.new()
	dungeon = Dungeon_Room.new(null, "stpt", 0)
	rng.randomize()
	gen_dungeon()
	dungeon.serialize("", true)
	
