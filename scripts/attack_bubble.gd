# --
# attack bubble

class_name AttackBubble extends Area2D

# refs
@onready var anim: AnimatedSprite2D = $anim

# vars
var type: Enums.AttackBubbleType
var speed: float = 25.0
var explode_speed: float = 10.0
var shot_direction: int = 1
var shot_source: Enums.ShotSource = Enums.ShotSource.None

# destroy
var is_exploding: bool = false

# cons anim names
const anim_default = &"default"
const anim_explode = &"explode"


func _ready() -> void:
	
	# look animation
	anim.set_animation(anim_default)

	# play animation
	anim.play()

	# explode
	is_exploding = false


func _process(delta: float) -> void:

	# update pos
	var move_update: Vector2 = self.update_bubble_movement()

	# update transform
	position += delta * move_update


func set_stats(new_stats: AttackBubbleStats, target_shot_source: Enums.ShotSource):

	# set vars
	speed = new_stats.get_speed()
	type = new_stats.get_type()

	# anim sprites
	anim.sprite_frames = new_stats.get_sprite_frames()

	# shot source and direction
	shot_source = target_shot_source
	shot_direction = 1 if target_shot_source == Enums.ShotSource.ShotWizard else -1

	# switch direction
	if target_shot_source == Enums.ShotSource.ShotWizard: return
	self.transform.x *= -1


func update_bubble_movement() -> Vector2:

	# explodes
	if is_exploding: return Vector2(explode_speed * shot_direction, 0.0)

	# simple update
	return speed * Vector2(speed * shot_direction, 0.0)


func destroy_bubble():

	# look animation
	anim.set_animation(anim_explode)

	# play animation
	anim.play()

	# explode
	is_exploding = true


# --
# signal methods

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.destroy_bubble()


func _on_area_entered(area: Area2D) -> void:

	# returns
	if shot_source == Enums.ShotSource.ShotCharacter: return
	if area is CharacterFighter: return
	if area is Wizard: return
	if area.shot_source == self.shot_source: return
	if is_exploding: return

	# destroy both condition
	var destroy_both: bool = false
	destroy_both = destroy_both or (self.type == Enums.AttackBubbleType.Red and area.type == Enums.AttackBubbleType.Blue)
	destroy_both = destroy_both or (self.type == Enums.AttackBubbleType.Blue and area.type == Enums.AttackBubbleType.Green)
	destroy_both = destroy_both or (self.type == Enums.AttackBubbleType.Green and area.type == Enums.AttackBubbleType.Red)

	# destroy both
	if destroy_both:
		area.destroy_bubble()
		self.destroy_bubble()
		return

	# destroy character bubble
	area.destroy_bubble()


func _on_anim_animation_finished() -> void:

	# only for exploding
	if not is_exploding: return
	queue_free()
