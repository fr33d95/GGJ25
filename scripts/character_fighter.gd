# --
# character fighter

class_name CharacterFighter extends Area2D

# resources
@export var attack_bubble_scene: PackedScene
@export var attack_bubble_stats: Array[AttackBubbleStats]

# refs
@onready var anim: AnimatedSprite2D = $anim

# vars
var num_hits

# const anim
const anim_fight_idle = &"fight_idle"
const anim_hit = &"hit"
const anim_suffocate = &"suffocate"
const anim_attack = &"attack"
const anim_die = &"die"


func _ready() -> void:
	num_hits = 0

	# look animation
	anim.set_animation(anim_fight_idle)

	# play animation
	anim.play()


func _process(_delta: float) -> void:

	# test
	if Input.is_action_just_pressed("test_shot"): spawn_attack_bubble(Enums.AttackBubbleType.None)

	if Input.is_action_just_pressed("test_shot_char_red"): spawn_attack_bubble(Enums.AttackBubbleType.Red)
	if Input.is_action_just_pressed("test_shot_char_green"): spawn_attack_bubble(Enums.AttackBubbleType.Green)
	if Input.is_action_just_pressed("test_shot_char_blue"): spawn_attack_bubble(Enums.AttackBubbleType.Blue)

func reset() -> void:
	num_hits = 0


func spawn_attack_bubble(bubble_id: Enums.AttackBubbleType) -> void:
	
	assert(bubble_id <= Enums.AttackBubbleType.None)

	# set id
	var bi: int = randi_range(0, Enums.AttackBubbleType.None - 1) if bubble_id == Enums.AttackBubbleType.None else bubble_id

	# bubble instance
	var attack_bubble = attack_bubble_scene.instantiate()

	# add
	add_child(attack_bubble)

	# settings
	attack_bubble.set_stats(attack_bubble_stats[bi], Enums.ShotSource.ShotCharacter)


func hit():
	print("character is hit")


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
	area.queue_free()
	
