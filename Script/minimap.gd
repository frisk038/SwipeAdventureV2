extends Control

var roomSize = Vector2(50, 50)
var roomSpacing = 20

func _ready():
	Dungeon.new_dungeon()
	
func _draw():
	draw_mini_map(Dungeon.dungeon, Vector2())

func draw_mini_map(room: Dungeon.Dungeon_Room, position: Vector2):
	draw_room(position, roomSize, room.level, room.type)

	var childPositions = []
	for i in range(room.rooms.size()):
		if room.rooms[i] != null:
			var childPosition = position + Vector2(roomSize.x + roomSpacing, (roomSize.y + roomSpacing) * i)
			draw_mini_map(room.rooms[i], childPosition)
			childPositions.append(childPosition)

	if childPositions.size() > 0:
		draw_links(position + Vector2(roomSize.x, roomSize.y / 2), childPositions)

func draw_room(position: Vector2, size: Vector2, level: int, type: String):
	var color = get_room_color(type)
	draw_rect(Rect2(position, size), color)

func draw_links(startPosition: Vector2, childPositions: Array):
	var endPosition = Vector2(startPosition.x, childPositions[0].y + roomSize.y / 2)
	draw_line(startPosition, endPosition, Color(0, 0, 0), 2)

	for i in range(childPositions.size()):
		var childPosition = childPositions[i]
		var childStartPosition = Vector2(startPosition.x, childPosition.y + roomSize.y / 2)
		draw_line(childStartPosition, childPosition, Color(0, 0, 0), 2)

func get_room_color(type: String) -> Color:
	match type:
		Dungeon.RM_TYPE_START:
			return Color(0, 1, 0)  # Green
		Dungeon.RM_TYPE_CHEST:
			return Color(1, 1, 0)  # Yellow
		Dungeon.RM_TYPE_FIGHT:
			return Color(1, 0, 0)  # Red
		Dungeon.RM_TYPE_SHOP:
			return Color(0, 0, 1)  # Blue
		Dungeon.RM_TYPE_REST:
			return Color(0.5, 0.5, 0.5)  # Gray
		Dungeon.RM_TYPE_TRAP:
			return Color(0.5, 0, 0.5)  # Purple
		Dungeon.RM_TYPE_ELITE:
			return Color(0.8, 0, 0.8)  # Magenta
		"Event":
			return Color(0, 0.5, 0.5)  # Teal
		_:  # Default color for unknown types
			return Color(0, 0, 0)  # Black
