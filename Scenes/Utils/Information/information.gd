extends Node2D




const FONT = preload("res://Assets/fonts/PixelOperator8.ttf")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var label = Label.new()
		label.text = "The Pipe Seems to be leaking,
		 is it contaminating
		the groundwater below ?"
		label.add_theme_font_size_override("font_size", 8);
		label.add_theme_font_override("font", FONT)
		add_child(label)
		
