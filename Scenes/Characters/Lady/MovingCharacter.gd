extends CharacterBody2D


@export var patrol_points: Node
@export var speed: int = 1500
@export var wait_time: int = 3



@onready var character_sprite = $characterSprite
@onready var timer = $Timer


const GRAVITY: int = 1000


enum State { Idle, Walk}
var current_state : State
var direction: Vector2 = Vector2.LEFT

# patrol points variables
var number_of_points: int
var point_positions: Array[Vector2]
var current_point: Vector2
var current_point_position: int




var can_walk: bool = true


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
	character_gravity(delta)
	character_idle(delta)
	character_walk(delta)
	
	move_and_slide()
	
	character_animation()

func  character_gravity(delta: float):
	velocity.y += GRAVITY * delta

func character_idle(delta: float):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		current_state = State.Idle

func character_walk(delta: float):
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
		
	
	character_sprite.flip_h = direction.x < 0

func character_animation():
	if current_state == State.Idle && !can_walk:
		character_sprite.play("idle")
	elif current_state == State.Walk && can_walk:
		character_sprite.play("walk")




func _on_timer_timeout() -> void:
	can_walk = true
