# --
# wizzard

class_name Wizzard extends Area2D

# resources
@export var attack_bubble_scene: PackedScene
@export var attack_bubble_stats: Array[AttackBubbleStats]

# vars
var num_hits


func _ready() -> void:
	num_hits = 0


func _process(_delta: float) -> void:

	# test
	if Input.is_action_just_pressed("test_shot"):
			
		# spawn a attack bubble
		spawn_attack_bubble()


func reset() -> void:
	num_hits = 0


func spawn_attack_bubble() -> void:
	
	# bubble instance
	var attack_bubble = attack_bubble_scene.instantiate()

	# settings
	attack_bubble.set_stats(attack_bubble_stats[0], Enums.ShotSource.ShotWizzard)

	# add
	add_child(attack_bubble)


func hit():
	print("wizzard is hit")


# --
# signals

func _on_area_entered(area: Area2D) -> void:
	print("area: ", area)

	# returns
	if not area is AttackBubble: return
	if area.shot_source == Enums.ShotSource.ShotWizzard: return

	# hit by shot
	self.hit()
	area.queue_free()

	print(area.type)
