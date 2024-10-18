extends Node2D
@onready var label: Label = $Label
@export var labelText : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = labelText
	label.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		label.show()
