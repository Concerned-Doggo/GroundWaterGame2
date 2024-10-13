extends Node2D

@export var award_amount : int  = 5

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	label.hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		
		sprite_2d.hide()
		label.text = "%s" % award_amount
		CollectiblesManager.give_pickup_award(award_amount)
		label.show()
		
		var tween = get_tree().create_tween()
		tween.tween_property(label, "position", Vector2(label.position.x, label.position.y + -10), 0.5).from_current()
		tween.tween_callback(queue_free)
		area_2d.queue_free()
