extends Node2D

const LABEL = preload("res://Scenes/Utils/Labels/label.tscn")

const PIPE_FIXED = preload("res://Assets/sprites/Images/PipeFixed.png")
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

var isFixed : bool = false

func changePipe():
	if isFixed == true:
		sprite_2d.texture = PIPE_FIXED


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && isFixed == false:
		var label = LABEL.instantiate()
		label.text = "Fixing..."
		#label.position.x = body.global_position.x 
		#label.position.y = body.global_position.y
		add_child(label)
		timer.start()
		await timer.timeout
		label.queue_free()
		changePipe()


func _on_timer_timeout() -> void:
	isFixed = true
	print("done timeout")
