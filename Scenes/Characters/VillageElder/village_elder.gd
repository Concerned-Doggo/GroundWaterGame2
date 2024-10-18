extends CharacterBody2D

const VILLAGE_ELDER_DIALOGUE = preload("res://Dialogue/Dialogue.tscn")

@export var speed: int = 1500

@onready var character_sprite = $characterSprite

# dialogue
var count : int = 0
var timeline : String = "Village-Elders-timeline"
var isPlayerPresent : bool = false

const GRAVITY: int = 1000



func _physics_process(delta):
	character_gravity(delta)
	
	move_and_slide()
	
	character_animation()

func  character_gravity(delta: float):
	velocity.y += GRAVITY * delta


func character_animation():
	character_sprite.play("idle")



func player_speak_with_elder():
	Dialogic.signal_event.connect(dialogic_signal)
	count += 1
	if count >= 1 and LevelManager3.hasSeenLeakage == true and LevelManager3.hasFixedPipe == false:
		timeline = "VillageElder-After-Player-concern-timeline"
	elif count > 1 and LevelManager3.hasFixedPipe == true:
		timeline = "VillageElderThanksPlayer-timeline"
	Dialogic.start(timeline)
	

func dialogic_signal(arg : String):
	if arg == "player has tools":
		LevelManager3.spokeToElder()
	


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_speak_with_elder()
