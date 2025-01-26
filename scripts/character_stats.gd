extends Node

const MAX_OXYGEN: float = 100.0 # maximum health

@export var current_oxygen: float = MAX_OXYGEN # current health
@export var in_fight: bool = false # if player is swimming or in a fight

var decrease_oxygen_rate = 1.0 # how much the o gets decreased over time
var decrease_oxygen_interval = 1.0 # after how much time the oxygen gets decreased
var oxygen_timer = 0.0
var is_alive = true

# after a specific time the player looses oxygen while swimming
func _process(delta):
	if not in_fight:
		oxygen_timer += delta
		if oxygen_timer >= decrease_oxygen_interval:
			oxygen_timer = 0.0
			decrease_oxygen(decrease_oxygen_rate)

# decrease the oxygen when hit or over time
func decrease_oxygen(decrease_value):
	if current_oxygen > 0.0:
		current_oxygen -= decrease_value
		current_oxygen = clamp(current_oxygen, 0, MAX_OXYGEN)
	if current_oxygen <= 0.0:
		die()

# increase the oxygen when o2 bubble is collected
func increase_oxygen(increase_value):
	if current_oxygen < MAX_OXYGEN:
		current_oxygen += increase_value
		current_oxygen = clamp(current_oxygen, 0, MAX_OXYGEN)

func die():
	is_alive = false
