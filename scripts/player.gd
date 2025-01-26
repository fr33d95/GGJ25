extends CharacterBody2D

const SPEED = 300.0

var oxygen = 100
var oxygen_decrease_rate = 1
var player_is_alive = true
var player_swims_down = false
var screen_size = Vector2(1000, 140) # TODO set initial bottle space


func _ready():
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
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_Timer_timeout():
	oxygen -= oxygen_decrease_rate
	if oxygen <= 0:
		player_is_alive = false
		$AnimatedSprite2D.stop()
