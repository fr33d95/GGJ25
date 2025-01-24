extends Node2D

# resources
@export var main_world: PackedScene

# refs
@onready var world = $world
@onready var title = $title_canvas
@onready var credits = $credits_canvas
@onready var win = $win_canvas
#@onready var bgm_player = $BGM_Player
#@onready var bgm_intro = $BGM_intro

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
	
	# start  with intro
	world.add_child(main_world.instantiate())

	# signal connections
	#world.get_node("intro_world").finished.connect(finished_intro_world)

	# info
	#world.get_node("intro_world").info()

	# todo: bgm
	#bgm_title.stop()
	#bgm_sea1.play()

	# title
	title.hide()
	win.hide()
	credits.hide()

	# is playing
	is_playing = true



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
	#bgm_player.stream = load("res://audio/bgm/xxx.mp3")
	#bgm_player.play()
	#bgm_intro.play()


func win_to_credits(): self.title_to_credits()


func game_to_title():

	# clean_world
	self.clean_world()

	# canvas
	title.show()
	credits.hide()
	win.hide()


func win_game():

	# canvas
	title.hide()
	credits.hide()
	win.show()


func end_game():

	# free all
	get_tree().quit()
