extends Node2D

@onready var bosslabel = $"../bosslabel"
@export var isBossDead: bool  = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isBossDead:
		bosslabel.text = "Boss Slained!"
