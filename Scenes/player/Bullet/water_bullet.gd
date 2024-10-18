extends AnimatedSprite2D

var bullet_impact_effect = preload("res://Scenes/player/Bullet/impact/bullet_impact_effect.tscn")



var speed: int = 400
var direction: float
var damage_amount: int = 1

func _physics_process(delta):
	if direction == 0:
		direction = Input.get_axis("move_left", "move_right")
	flip_h = direction < 0
	move_local_x(delta * direction * speed)


func _on_timer_timeout():
	queue_free()

func get_damage_amount() -> int:
	return damage_amount

func _on_hit_box_area_entered(area):
	print("bullet area entered")
	bullet_impact()


func _on_hit_box_body_entered(body):
	print("bullet body entered")
	bullet_impact()

func bullet_impact():
	var bullet_impact_effect_instance = bullet_impact_effect.instantiate() as Node2D
	bullet_impact_effect_instance.global_position = global_position
	get_parent().add_child(bullet_impact_effect_instance)
	queue_free()
