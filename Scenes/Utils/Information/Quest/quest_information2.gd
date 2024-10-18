extends Node2D

const LABEL = preload("res://Scenes/Utils/Labels/label.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var label = LABEL.instantiate()
		label.text = "The leakage is contaminating 
		the water rapidly,
		Is that why the
		villagers were sick?"
		add_child(label)
