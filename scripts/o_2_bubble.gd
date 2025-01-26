extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_speed(x_speed: float, y_speed: float) -> void:
	linear_velocity += Vector2(x_speed,y_speed)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free();
	
func hit():
	$AudioStreamPlayer2D.play()
	linear_velocity = Vector2(0,0)
	$AnimatedSprite2D.animation = "hit"
	$CollisionShape2D.set_deferred("disabled", true)

func remove_Bubble() -> void:
	queue_free();
