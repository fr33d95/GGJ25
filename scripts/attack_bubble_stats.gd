# --
# attack bubble stats

class_name AttackBubbleStats extends Resource

# resources
@export var sprite_frames: SpriteFrames

# vars
@export var attack_bubble_type: Enums.AttackBubbleType
@export var speed: float


# --
# getter

func get_sprite_frames(): return sprite_frames
func get_speed(): return speed
func get_type(): return attack_bubble_type
