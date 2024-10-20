extends CharacterBody2D

var bullet = preload("res://Scenes/player/Bullet/water_bullet.tscn")
#var player_death_effect = preload("res://Scenes/player/PlayerDeathEffect/player_death_effect.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle = $Muzzle
@onready var hit_animation_player: AnimationPlayer = $HitAnimationPlayer


@export var speed: int = 400.0
@export var max_horizontal_speed: int = 200
@export var slow_down_speed: int= 3000

const GRAVITY: int = 1000

# Jump variables
@export var jump_velocity: int = -300.0
@export var jump_horizontal: int = 100
@export var max_jump_horizontal_speed = 200
@export var jump_count : int = 2

enum State { Idle, Run, Jump, Shoot } 

var current_state : State
# -1 = left, 1 = right
var player_direction = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# variables for shooting bullets
var muzzle_position 
var current_jump_count : int = 0

func _ready():
	current_state = State.Idle
	muzzle_position = muzzle.position

func _physics_process(delta: float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	
	player_muzzle_position()
	player_shooting(delta)
	
	move_and_slide()
	
	
	player_animation()
	#print(str(State.keys()[current_state]))


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
		velocity.x += direction * speed * delta
		velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed) 
	else:
		velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)
	
	
	if direction != 0:
		current_state = State.Run
		animated_sprite_2d.flip_h = false if direction == 1 else true


func player_jump(delta: float):
	var jump_input : bool = Input.is_action_just_pressed("jump")
	# checking input
	if is_on_floor() and jump_input:
		current_jump_count = 0
		velocity.y = jump_velocity
		current_jump_count += 1
		current_state = State.Jump
	
	if !is_on_floor() and jump_input and current_jump_count < jump_count:
		velocity.y = jump_velocity
		current_jump_count += 1
		current_state = State.Jump
	
	# checking if player currently jumping or not
	if !is_on_floor() and current_state == State.Jump:
		var direction = input_movement()
		velocity.x += direction * jump_horizontal * delta
		velocity.x = clamp(velocity.x, -max_jump_horizontal_speed, max_jump_horizontal_speed) 

func player_muzzle_position():
	var direction = input_movement()
	if direction < 0:
		muzzle.position.x = -muzzle_position.x
	else:
		muzzle_position.x = muzzle_position.x

func player_shooting(delta: float):
	var direction = input_movement()
	if Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.direction = direction
		get_parent().add_child(bullet_instance)
		current_state = State.Shoot

func player_animation():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run and animated_sprite_2d.animation != "run_shoot":
		animated_sprite_2d.play("run")
	elif current_state == State.Jump and current_jump_count == 1:
		animated_sprite_2d.play("jump")
	elif current_state == State.Jump and current_jump_count > 1:
		animated_sprite_2d.play("doubleJump")
	elif current_state == State.Shoot:
		animated_sprite_2d.play("run_shoot")

func player_death():
	animated_sprite_2d.play("death")
	queue_free()

func input_movement():
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print("enemy entered ", body.damage_amount )
		hit_animation_player.play("Hit")
		HealthManager.decrease_health(body.damage_amount)
	
	if HealthManager.current_health == 0:
		player_death()
