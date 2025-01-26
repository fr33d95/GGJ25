extends Node2D

# resources
@export var main_world: PackedScene
var fight_world_scene: PackedScene = preload("res://scenes/wizard_fight_world.tscn")

# refs
@onready var world = $world
@onready var title = $title_canvas
@onready var credits = $credits_canvas
@onready var win = $win_canvas
@onready var bgm_down = $bgm_down
@onready var bgm_wizard_fight = $bgm_wizard_fight
@onready var bgm_up = $bgm_up


# playing flag
var is_playing:bool = false

func _ready() -> void:
	
	# signal connections
	title.start_game.connect(self.start_new_game)
	title.credits.connect(self.title_to_credits)
	title.end_game.connect(self.end_game)
	credits.end_credits.connect(self.credits_to_title)
	win.end_win.connect(self.win_to_credits)

	# canvas handling
	title.show()
	win.hide()
	credits.hide()

	# play down also in title
	bgm_down.play()

	# is playing
	is_playing = false


func _process(_delta: float) -> void:

	# leave cases
	if credits.visible: return
	if win.visible: return

	# escape
	if Input.is_action_just_pressed("escape"):

		# end if title canvas
		if title.visible: 
			get_tree().quit()
			return

		# title
		if not is_playing: return
		game_to_title()

		# todo: pause
		# pause
		#if get_tree().paused: return

		# pause game
		#self.pause_game()


# --
# game

func start_new_game():

	# clean
	clean_world()
	
	var bottleWorld =main_world.instantiate()
	# start  with intro
	world.add_child(bottleWorld)
	bottleWorld.start_downwards_game()
	
	# signal connections
	bottleWorld.win.connect(bottle_win_signal)
	bottleWorld.lose.connect(bottle_lose_signal)

	# title
	title.hide()
	win.hide()
	credits.hide()
	
	# is playing
	is_playing = true


func start_fight_world():
	print("test")
	# todo:
	# save stats

	print("start the bubble fight world")

	# clean
	clean_world()

	# world
	var wizard_fight_world = fight_world_scene.instantiate()

	# start  with intro
	world.add_child(wizard_fight_world)

	# make signal connections
	wizard_fight_world.fight_is_now_over_go_up.connect(self.start_up_the_bottle)

	# todo:
	# overwrite stats
	#wizard_fight_world.overwrite_character_stats()

	# bgm
	bgm_down.stop()
	bgm_wizard_fight.play()


func start_up_the_bottle():

	# clean
	clean_world()

	var bottleWorld =main_world.instantiate()
	# start  with intro
	world.add_child(bottleWorld)
	bottleWorld.start_upwards_game()
	
	# signal connections
	bottleWorld.win.connect(bottle_win_signal)
	bottleWorld.lose.connect(bottle_lose_signal)
	# todo:
	# start up the bottle world instantiate

	# bgm
	bgm_wizard_fight.stop()
	bgm_up.play()


func clean_world():

	# remove children of world
	for child in world.get_children(): child.queue_free()

	# wait for delete
	await get_tree().process_frame


func title_to_credits():
	credits.show()
	title.hide()
	win.hide()


func credits_to_title():
	title.show()
	credits.hide()
	win.hide()


func win_to_credits(): self.title_to_credits()


func game_to_title():

	# clean_world
	self.clean_world()

	# canvas
	title.show()
	credits.hide()
	win.hide()

	# bgm
	bgm_down.stop()
	bgm_wizard_fight.stop()
	bgm_up.stop()
	bgm_down.play()

func bottle_win_signal(upwards: bool):
	if(upwards):
		win_game()
	else:
		start_fight_world()
		
func bottle_lose_signal():
	win_game()
func win_game():

	# canvas
	title.hide()
	credits.hide()
	win.show()


func end_game():

	# free all
	get_tree().quit()
