extends Control

onready var roaming_ui = $roaming_control
onready var chest_ui = $chest_event
onready var elite_ui = $elite_event
onready var rest_ui = $rest_event
onready var shop_ui = $shop_event
onready var trap_ui = $trap_event
onready var fight_ui = $fight_event

onready var event_uis = {
	Dungeon.RM_TYPE_CHEST: chest_ui, 
	Dungeon.RM_TYPE_ELITE: elite_ui, 
	Dungeon.RM_TYPE_FIGHT: fight_ui, 
	Dungeon.RM_TYPE_REST: rest_ui,
	Dungeon.RM_TYPE_SHOP: shop_ui, 
	Dungeon.RM_TYPE_TRAP: trap_ui
}

func _ready():
	var err = Dungeon.connect("new_room", self, "_on_Dungeon_new_room")
	if err != OK:
		print("cant connect new_path signal !", err)
	
	for ui in event_uis:
		err = event_uis[ui].connect("event_resolved", self, "_on_Event_resolved")
		if err != OK:
			print("cant connect resolve signal !", ui,  err)
	_on_Dungeon_new_room()

func _hide_event_ui():
	roaming_ui.visible = false
	for ui in event_uis:
		event_uis[ui].visible = false

func _on_Dungeon_new_room():
	if Dungeon.current_room.type == Dungeon.RM_TYPE_START:
		_on_Event_resolved()
		return

	var evt_ui:Control = event_uis[Dungeon.current_room.type]
	evt_ui.visible = true
	evt_ui.call("resolve")

func _on_Event_resolved():
	_hide_event_ui()
	roaming_ui.visible = true
	roaming_ui.update()
