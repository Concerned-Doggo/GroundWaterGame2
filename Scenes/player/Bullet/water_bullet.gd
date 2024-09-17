extends AnimatedSprite2D

var bullet_impact_effect = preload("res://Scenes/player/Bullet/impact/bullet_impact_effect.tscn")

@onready var water_bullet = $"."

var speed: int = 400
var direction: int

func _physics_process(delta):
	water_bullet.flip_h = direction < 0
	move_local_x(delta * direction * speed)


func _on_timer_timeout():
	queue_free()


func _on_hit_box_area_entered(area):
	print("bullet area entered")


func _on_hit_box_body_entered(body):
	print("bullet body entered")

func bullet_impact():
	var bullet_impact_instance = bullet_impact_effect.instantiate() as Node2D
	bullet_impact_effect.global_position = global_position
	get_parent().add_child(bullet_impact_instance)
