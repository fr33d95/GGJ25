extends CharacterBody2D

const SPEED = 350.0
const MIN_SCREEN = 330
const MAX_SCREEN = 980

@export var player_swims_down: bool = true

func _ready():
	pass
	
func set_swimstate_down(swimstate: bool):
	player_swims_down = swimstate
	if player_swims_down:
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.play()

	elif not player_swims_down:
		$AnimatedSprite2D.flip_v = true
		$AnimatedSprite2D.play()

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	
	position += velocity * delta
	position.x = clamp(position.x, MIN_SCREEN, MAX_SCREEN)
