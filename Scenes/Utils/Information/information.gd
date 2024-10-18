extends Node2D



const LABEL = preload("res://Scenes/Utils/Labels/label.tscn")
const FONT = preload("res://Assets/fonts/PixelOperator8.ttf")
var count = 0

var label = LABEL.instantiate()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		label.add_theme_font_size_override("font_size", 8);
		label.add_theme_font_override("font", FONT)
		
		count += 1
		
		if count < 2:
			label.text = "The Pipe Seems to be leaking,
			is it contaminating
			the groundwater below?"
		elif count >= 2:
			label.text = "Maybe the Village elder 
			knows how to fix it."
		
		add_child(label)
