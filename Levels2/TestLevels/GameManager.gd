extends Node2D

@onready var bosslabel = $"../bosslabel"
@export var isBossDead: bool  = false


func _process(delta):
	if isBossDead:
		bosslabel.text = "Boss Slained!"
