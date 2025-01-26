extends Node2D
signal win(upwards:bool)
signal lose
signal o2changed(new_value:int)

@export var depth = 10;
@export var scroll_stop_threshhold = 55;
@export var o2_bubble_scene: PackedScene;
@export var upwards_bubble_scene: PackedScene;
@export var scollspeed = 100;
@export var bubblespeed_min = 200;
@export var bubblespeed_max = 250;
@export var scrollspeed_offset_upwards_hit = 150;
@export var o2_depletion_downwards = 1;
@export var o2_depletion_upwards = 5;
@export var o2_gain_bubble = 10;
@export var depth_decrease_hit = 5;
@export var o2_status = 100;


var current_depth = 0;
var isUpwards = false;
var isUpwardsHit = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

func start_downwards_game():
	print("down")
	isUpwards = false;
	current_depth =0;
	startup();
	$Player.set_swimstate_down(true);
	
	
func start_upwards_game():
	isUpwards = true;
	current_depth =depth;
	startup();
	$Player.set_swimstate_down(false);
	
func startup():
	print("start")
	o2_status = 100;
	$DepthTimer.start();
	$O2_BubbleSpawner.start();
	$Upwards_Bubble_Spawner.start();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var offset = Vector2(0,scollspeed)*delta
	if(isUpwards):
		offset = offset * -1;
	if(isUpwardsHit):
			offset -= Vector2(0,scrollspeed_offset_upwards_hit)*delta
	if(current_depth < scroll_stop_threshhold):
		$Background.scroll_base_offset -=offset;
	$BottleBackground.scroll_base_offset -= offset;


func _on_depth_timer_timeout() -> void:
	print(isUpwards)
	print(current_depth)
	if(isUpwards):
		current_depth -=1;
		if(current_depth <= 0):
			win_emit();
	else:
		current_depth += 1;
		print(current_depth)
		if(current_depth >= depth):
			print("win")
			win_emit();
	


func _on_o_2_bubble_spawner_timeout() -> void:
	var bubble = o2_bubble_scene.instantiate()

	var bubble_spawn_location = $BubbleSpawner/BubbleSpawnerLocation
	bubble_spawn_location.progress_ratio = randf()

	var direction = bubble_spawn_location.rotation - PI / 2

	bubble.position = bubble_spawn_location.position

	bubble.rotation = direction

	var offset = scollspeed;
	if(isUpwards):
			offset = offset * -1
	if(isUpwardsHit):
			offset -= scrollspeed_offset_upwards_hit
	var velocity = Vector2(randf_range(bubblespeed_min + offset, bubblespeed_max + offset), 0.0)
	bubble.linear_velocity = velocity.rotated(direction)

	add_child(bubble)


func _on_upwards_bubble_spawner_timeout() -> void:
	
	var bubble = upwards_bubble_scene.instantiate()

	var bubble_spawn_location = $BubbleSpawner/BubbleSpawnerLocation
	bubble_spawn_location.progress_ratio = randf()

	var direction = bubble_spawn_location.rotation - PI / 2

	bubble.position = bubble_spawn_location.position

	bubble.rotation = direction

	var offset = scollspeed;
	if(isUpwards):
			offset = offset * -1
	if(isUpwardsHit):
			offset -= scrollspeed_offset_upwards_hit
	var velocity = Vector2(randf_range(bubblespeed_min + offset, bubblespeed_max + offset), 0.0)
	bubble.linear_velocity = velocity.rotated(direction)

	add_child(bubble)
	
func upwards_hit():
	current_depth -= depth_decrease_hit;
	if(current_depth < 0):
		current_depth = 0;
	isUpwardsHit = true;
	$Upwards_Hit_Timer.start();
	updateSpeed(scrollspeed_offset_upwards_hit);

func o2_hit():
	updateO2(o2_gain_bubble)
	
func win_emit ():
	win.emit(isUpwards)

func O2_emit ():
	o2changed.emit(o2_status);
func loose_emit():
	lose.emit();
	
func updateO2(gain: int):
	o2_status += gain;
	O2_emit();

func setO2(value: int):
	o2_status = value;
	O2_emit();
	
func updateSpeed (speed: float):
	get_tree().call_group("o2_bubbles", "update_speed", 0.0, speed);
	get_tree().call_group("upwards_bubbles", "update_speed", 0.0, speed);


func _on_upwards_hit_timer_timeout() -> void:
	isUpwardsHit = false;
	updateSpeed(-scrollspeed_offset_upwards_hit);
