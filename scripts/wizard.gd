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
@export var cooldown_times: Array[float] = [2.0, 1.0, 0.5]

# refs
@onready var anim: AnimatedSprite2D = $anim
@onready var death_timer: Timer = $death_timer
@onready var invincible_timer: Timer = $invincible_timer
@onready var attack_bubble_container: Node2D = $attack_bubble_container

# vars
var is_dead: bool = false
var is_invincible: bool = false
var num_hits: int = 0
var cooldown_timer: Timer = null

var actual_anim_state = null

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
	# if Input.is_action_just_pressed("test_shot"): spawn_attack_bubble(Enums.AttackBubbleType.None)
	# if Input.is_action_just_pressed("test_shot_wiz_red"): spawn_attack_bubble(Enums.AttackBubbleType.Red)
	# if Input.is_action_just_pressed("test_shot_wiz_green"): spawn_attack_bubble(Enums.AttackBubbleType.Green)
	# if Input.is_action_just_pressed("test_shot_wiz_blue"): spawn_attack_bubble(Enums.AttackBubbleType.Blue)

	# auto attack
	self.auto_attack_update()


func reset() -> void:
	num_hits = 0
	is_dead = false

	# look animation
	anim.set_animation(anim_fight_idle)

	# play animation
	anim.play()

	# anim state
	actual_anim_state = anim_fight_idle


func auto_attack_update():

	# returns
	if is_dead: return

	# still bubbles
	if attack_bubble_container.get_child_count(): return

	# no bubbles start cooldown timer
	start_cooldown_timer()


func start_cooldown_timer():

	# start fight
	if not cooldown_timer == null: return

	# create timer
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.timeout.connect(self._on_cooldown_timer_timeout)

	# set time
	cooldown_timer.wait_time = cooldown_times[num_hits]
	cooldown_timer.start()


func spawn_attack_bubble(bubble_id: Enums.AttackBubbleType) -> void:
	
	assert(bubble_id <= Enums.AttackBubbleType.None)

	# set id
	var bi: int = randi_range(0, Enums.AttackBubbleType.None - 1) if bubble_id == Enums.AttackBubbleType.None else bubble_id

	# bubble instance
	var attack_bubble = attack_bubble_scene.instantiate()

	# add
	attack_bubble_container.add_child(attack_bubble)

	# settings
	attack_bubble.set_stats(attack_bubble_stats[bi], Enums.ShotSource.ShotWizard)

	# look animation
	anim.set_animation(anim_attack)

	# play animation
	anim.play()

	# anim state
	actual_anim_state = anim_attack


func hit():

	# returns
	if is_dead: return
	if is_invincible: 
		print("wizard is invincible")
		return

	# add number of hits
	num_hits += 1

	# hit message
	print("wizard is hit: ", num_hits, "/", max_hits)

	# make him invincible
	is_invincible = true
	invincible_timer.start()

	# hit animation
	anim.set_animation(anim_hit)

	# play animation
	anim.play()

	# anim state
	actual_anim_state = anim_hit

	# death
	if num_hits >= max_hits: 

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
# signal methods

func _on_area_entered(area: Area2D) -> void:

	# returnstzrrgbr
	if not area is AttackBubble: return
	if area.shot_source == Enums.ShotSource.ShotWizard: return

	# hit by shot
	self.hit()
	area.destroy_bubble()


func _on_cooldown_timer_timeout():

	# spawn attack
	self.spawn_attack_bubble(Enums.AttackBubbleType.None)
	cooldown_timer.stop()
	cooldown_timer.queue_free()


func _on_death_timer_timeout() -> void:

	# dead emit
	print("death of wizard after timer")
	the_evil_wizard_is_dead.emit()


func _on_invincible_timer_timeout() -> void:
	is_invincible = false
	invincible_timer.stop()


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
