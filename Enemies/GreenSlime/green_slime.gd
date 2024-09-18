extends CharacterBody2D

@export var boss_defeater : Label
@export var patrol_points: Node
@export var speed: int = 1500
@export var wait_time: int = 3
# enemy health
@export var health_amount: int = 3


@onready var enemy_sprite = $EnemySprite
@onready var timer = $Timer


const GRAVITY: int = 1000


enum State { Idle, Walk, Hurt }
var current_state : State
var direction: Vector2 = Vector2.LEFT

# patrol points variables
var number_of_points: int
var point_positions: Array[Vector2]
var current_point: Vector2
var current_point_position: int
@onready var game_manager = %GameManager



var can_walk: bool = false


func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No patrol points")
	
	timer.wait_time = wait_time
	current_state = State.Idle

func _physics_process(delta):
	enemy_gravity(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	
	move_and_slide()
	
	enemy_animation()

func  enemy_gravity(delta: float):
	velocity.y += GRAVITY * delta

func enemy_idle(delta: float):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		current_state = State.Idle

func enemy_walk(delta: float):
	if !can_walk:
		return
	
	if abs(position.x - current_point.x) > 0.5:
		#keep walking
		velocity.x = direction.x * speed * delta
		current_state = State.Walk
	else:
		current_point_position = (current_point_position + 1) % number_of_points
	
		current_point = point_positions[current_point_position]
	
		if(current_point.x > position.x):
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
			
		can_walk = false
		timer.start()
		await timer.timeout
		
	
	enemy_sprite.flip_h = direction.x < 0

func enemy_animation():
	if current_state == State.Idle && !can_walk:
		enemy_sprite.play("idle")
	elif current_state == State.Walk && can_walk:
		enemy_sprite.play("walk")
	elif current_state == State.Hurt:
		enemy_sprite.play("hurt")

func _on_timer_timeout():
	can_walk = true



func _on_area_2d_area_entered(area: Area2D):
	print("hurtBox area entered")
	if area.get_parent().has_method("get_damage_amount"):
		# enemy hurt
		current_state = State.Hurt
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount
		
		if health_amount <= 0:
			game_manager.isBossDead = true
			queue_free()
