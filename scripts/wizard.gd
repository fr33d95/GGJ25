# --
# wizard

class_name Wizard extends Area2D

# signals
signal the_evil_wizard_is_dead


# resources
@export var attack_bubble_scene: PackedScene
@export var attack_bubble_stats: Array[AttackBubbleStats]

# settings
@export var max_hits: int = 3

# refs
@onready var anim: AnimatedSprite2D = $anim
@onready var death_timer: Timer = $death_timer

# vars
var is_dead: bool = false
var num_hits: int = 0

# const anim
const anim_fight_idle = &"fight_idle"
const anim_hit = &"hit"
const anim_attack = &"attack"
const anim_die = &"die"


func _ready() -> void:

	# reset characer
	self.reset()


func _process(_delta: float) -> void:

	# test
	if Input.is_action_just_pressed("test_shot"): spawn_attack_bubble(Enums.AttackBubbleType.None)

	if Input.is_action_just_pressed("test_shot_wiz_red"): spawn_attack_bubble(Enums.AttackBubbleType.Red)
	if Input.is_action_just_pressed("test_shot_wiz_green"): spawn_attack_bubble(Enums.AttackBubbleType.Green)
	if Input.is_action_just_pressed("test_shot_wiz_blue"): spawn_attack_bubble(Enums.AttackBubbleType.Blue)


func reset() -> void:
	num_hits = 0
	is_dead = false


func spawn_attack_bubble(bubble_id: Enums.AttackBubbleType) -> void:
	
	assert(bubble_id <= Enums.AttackBubbleType.None)

	# set id
	var bi: int = randi_range(0, Enums.AttackBubbleType.None - 1) if bubble_id == Enums.AttackBubbleType.None else bubble_id

	# bubble instance
	var attack_bubble = attack_bubble_scene.instantiate()

	# add
	add_child(attack_bubble)

	# settings
	attack_bubble.set_stats(attack_bubble_stats[bi], Enums.ShotSource.ShotWizard)


func hit():

	# returns
	if is_dead: return

	# add number of hits
	num_hits += 1

	# hit message
	print("wizard is hit: ", num_hits, "/", max_hits)

	# death
	if num_hits >= max_hits: 

		# look animation
		anim.set_animation(anim_die)

		# play animation
		anim.play()

		# death
		is_dead = true

		# start death timer
		death_timer.start()


# --
# signal methods

func _on_area_entered(area: Area2D) -> void:
	print("area: ", area)

	# returns
	if not area is AttackBubble: return
	if area.shot_source == Enums.ShotSource.ShotWizard: return

	# hit by shot
	self.hit()
	area.queue_free()

	print(area.type)


func _on_death_timer_timeout() -> void:

	# dead emit
	print("death of wizard after timer")
	the_evil_wizard_is_dead.emit()
