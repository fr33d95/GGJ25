extends ProgressBar


func set_oxygen_value(new_value):
	if new_value >= 100:
		value = 100
	elif new_value <= 0:
		value = 0
	else:
		value = new_value
