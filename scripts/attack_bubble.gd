# --
# attack bubble

class_name AttackBubble extends Area2D

# refs
@onready var anim: AnimatedSprite2D = $anim

var type: Enums.AttackBubbleType
var speed: float = 25.0
var shot_direction: int = 1
var shot_source: Enums.ShotSource = Enums.ShotSource.None

# cons anim names
const anim_default = &"default"
const anim_explode = &"explode"


func _ready() -> void:
	
	# look animation
	anim.set_animation(anim_default)

	# play animation
	anim.play()


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
	shot_direction = -1 if target_shot_source == Enums.ShotSource.ShotWizard else 1


func update_bubble_movement() -> Vector2:

	# simple update
	return speed * Vector2(speed * shot_direction, 0.0)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("destroy bubble")
	queue_free()


func _on_area_entered(area: Area2D) -> void:

	# returns
	if shot_source == Enums.ShotSource.ShotCharacter: return
	if area is CharacterFighter: return
	if area is Wizard: return
	if area.shot_source == self.shot_source: return

	# handle bubble input only wizard shots
	#match self.type:
	print("hit bubble: ", area.type)

	var destroy_both: bool = false

	# destroy both condition
	if self.type == Enums.AttackBubbleType.Red and area.type == Enums.AttackBubbleType.Blue: destroy_both = true
	if self.type == Enums.AttackBubbleType.Blue and area.type == Enums.AttackBubbleType.Green: destroy_both = true
	if self.type == Enums.AttackBubbleType.Green and area.type == Enums.AttackBubbleType.Red: destroy_both = true

	# destroy both
	if destroy_both:
		area.queue_free()
		self.queue_free()
		return

	# destroy character bubble
	area.queue_free()
