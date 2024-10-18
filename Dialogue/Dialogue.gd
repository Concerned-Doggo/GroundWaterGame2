extends Node2D

var count : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(dialogic_signal)
	var timeline : String
	if(count == 0):
		timeline = "Village-Elders-timeline"
		count += 1
	elif count == 1 :
		timeline = "VillageElder-After-Player-concern-timeline"
	Dialogic.start(timeline)


func dialogic_signal(arg : String):
	if arg == "player has tools":
		LevelManager3.spokeToElder()
