# --
# attack bubble stats

class_name AttackBubbleStats extends Resource

# resources
@export var sprite_frames: SpriteFrames

# vars
@export var attack_bubble_type: Enums.AttackBubbleType
@export var speed: float
@export var sfx_bubble_explode: Resource


# --
# getter

func get_sprite_frames(): return sprite_frames
func get_speed(): return speed
func get_type(): return attack_bubble_type
func get_sfx_bubble_explode_stream(): return sfx_bubble_explode
