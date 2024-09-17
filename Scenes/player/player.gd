extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D


@export var speed: int = 300.0
const GRAVITY: int = 1000

# Jump variables
@export var jump_velocity: int = -300.0
@export var jump_horizontal: int = 50

enum State { Idle, Run, Jump } 

var current_state : State
# -1 = left, 1 = right
var player_direction = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	current_state = State.Idle

func _physics_process(delta: float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	move_and_slide()
	
	
	player_animation()
	print(str(State.keys()[current_state]))


func player_falling(delta: float):
	if !is_on_floor():
		velocity.y +=  GRAVITY * delta

func player_idle(delta: float):
	if is_on_floor():
		current_state = State.Idle

func player_run(delta: float):
	if !is_on_floor():
		return
	
	
	var direction = input_movement()
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	
	if direction != 0:
		current_state = State.Run
		animated_sprite_2d.flip_h = false if direction == 1 else true


func player_jump(delta: float):
	# checking input
	if Input.is_action_just_pressed("jump"):
		current_state = State.Jump
		velocity.y = jump_velocity
		
	# checking if player currently jumping or not
	if not is_on_floor() and current_state == State.Jump:
		
		var direction = input_movement()
		velocity.x += direction * jump_horizontal * delta

func player_animation():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")

func input_movement():
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction
