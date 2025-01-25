# --
# attack bubble

class_name AttackBubble extends Area2D

var type: Enums.AttackBubbleType
var speed: float = 25.0
var shot_direction: int = 1
var shot_source: Enums.ShotSource = Enums.ShotSource.None

func _ready() -> void:
	pass


func _process(delta: float) -> void:

	# update pos
	var move_update: Vector2 = self.update_bubble_movement()

	# update transform
	position += delta * move_update


func set_stats(new_stats: AttackBubbleStats, target_shot_source: Enums.ShotSource):

	# set speed
	speed = new_stats.get_speed()

	# shot source and direction
	shot_source = target_shot_source
	shot_direction = -1 if target_shot_source == Enums.ShotSource.ShotWizzard else 1


func update_bubble_movement() -> Vector2:

	# simple update
	return speed * Vector2(speed * shot_direction, 0.0)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("destroy bubble")
	queue_free()
