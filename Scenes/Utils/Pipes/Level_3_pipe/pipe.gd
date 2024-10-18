extends Node2D

const LABEL = preload("res://Scenes/Utils/Labels/label.tscn")

const PIPE_FIXED = preload("res://Assets/sprites/Images/PipeFixed.png")
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
@onready var fix_instruction_label: Label = $FixInstructionLabel

var isFixed : bool = false
var canFix : bool = false


func _ready() -> void:
	fix_instruction_label.hide()

func changePipe():
	if isFixed == true:
		sprite_2d.texture = PIPE_FIXED
		LevelManager3.fixedPipe()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and isFixed == false and canFix == true:
		var label = LABEL.instantiate()
		label.text = "Fixing..."
		add_child(label)
		timer.start()
		await timer.timeout
		label.queue_free()
		changePipe()
		fix_instruction_label.queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and isFixed == false and LevelManager3.isReadyToFixPipe == true:
		fix_instruction_label.show()
		canFix = true


func _on_timer_timeout() -> void:
	isFixed = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canFix = false

func createNewLabel(text : String) -> Label:
	var label = Label.new()
	label.text = text
	return label
