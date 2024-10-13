extends Node
var level1 = preload("res://Levels2/TestLevels/test_level_1.tscn")
const PAUSE_MENU_SCREEN = preload("res://Scenes/UI/Menus/pause_menu_screen.tscn")
const MAIN_MENU_SCREEN = preload("res://Scenes/UI/Menus/main_menu_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	if get_tree().paused:
		continue_game()
		return
	
	transition_to_start(level1.resource_path)

func exit_game():
	get_tree().quit()

func pause_game():
	get_tree().paused = true
	var pause_menu_instance = PAUSE_MENU_SCREEN.instantiate()
	get_tree().get_root().add_child(pause_menu_instance)

func continue_game():
	get_tree().paused = false

func main_menu():
	var main_menu_instance = MAIN_MENU_SCREEN.instantiate()
	get_tree().get_root().add_child(main_menu_instance)

func transition_to_start(scene_path):
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(scene_path)
