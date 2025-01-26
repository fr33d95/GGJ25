# --
# character fighter

class_name CharacterFighter extends Area2D

# signals
signal the_poor_character_died_during_an_epic_fight

# resources
@export var attack_bubble_scene: PackedScene
@export var attack_bubble_stats: Array[AttackBubbleStats]

# settings
@export var max_num_attack_bubbles: int = 3

# refs
@onready var anim: AnimatedSprite2D = $anim
@onready var death_timer: Timer = $death_timer
@onready var attack_bubble_container: Node2D = $attack_bubble_container

# vars
var is_dead: bool = false
var num_hits
var actual_anim_state = null

# const anim
const anim_fight_idle = &"fight_idle"
const anim_hit = &"hit"
const anim_suffocate = &"suffocate"
const anim_attack = &"attack"
const anim_die = &"die"


func _ready() -> void:

	# number of hits
	num_hits = 0

	# dead flag
	is_dead = false

	# look animation
	anim.set_animation(anim_fight_idle)

	# play animation
	anim.play()

	# anim state
	actual_anim_state = anim_fight_idle


func _process(_delta: float) -> void:

	# attack
	if Input.is_action_just_pressed("move_left"): spawn_attack_bubble(Enums.AttackBubbleType.Red)
	if Input.is_action_just_pressed("move_right"): spawn_attack_bubble(Enums.AttackBubbleType.Green)
	if Input.is_action_just_pressed("up"): spawn_attack_bubble(Enums.AttackBubbleType.Blue)



func reset() -> void:
	num_hits = 0


func spawn_attack_bubble(bubble_id: Enums.AttackBubbleType) -> void:
	
	# max bubbles
	if attack_bubble_container.get_child_count() >= max_num_attack_bubbles: return

	assert(bubble_id <= Enums.AttackBubbleType.None)

	# set id
	var bi: int = randi_range(0, Enums.AttackBubbleType.None - 1) if bubble_id == Enums.AttackBubbleType.None else bubble_id

	# bubble instance
	var attack_bubble = attack_bubble_scene.instantiate()

	# add
	attack_bubble_container.add_child(attack_bubble)

	# settings
	attack_bubble.set_stats(attack_bubble_stats[bi], Enums.ShotSource.ShotCharacter)

	# look animation
	anim.set_animation(anim_attack)

	# play animation
	anim.play()

	# anim state
	actual_anim_state = anim_attack


func hit():

	# returns
	if is_dead: return

	print("character is hit")
	# todo:
	# loose oxygen

	# add number of hits
	num_hits += 1

	# hit animation
	anim.set_animation(anim_hit)

	# play animation
	anim.play()

	# anim state
	actual_anim_state = anim_hit


func die():

	# returns
	if is_dead: return

	# look animation
	anim.set_animation(anim_die)

	# play animation
	anim.play()

	# anim state
	actual_anim_state = anim_die

	# death
	is_dead = true

	# start death timer
	death_timer.start()


# --
# setter

func set_character_stats():
	# todo:
	pass


# --
# signal methods


func _on_area_entered(area: Area2D) -> void:

	# returns
	if not area is AttackBubble: return
	if area.shot_source == Enums.ShotSource.ShotCharacter: return

	# hit by shot
	self.hit()
	area.destroy_bubble()
	


func _on_death_timer_timeout() -> void:
	
	# emit signal of death
	print("death of character after epic fight")
	the_poor_character_died_during_an_epic_fight.emit()


func _on_anim_animation_finished() -> void:

	# returns
	if actual_anim_state == anim_fight_idle: return
	if actual_anim_state == anim_die: return

	# look animation
	anim.set_animation(anim_fight_idle)

	# play animation
	anim.play()

	# anim state
	actual_anim_state = anim_fight_idle
