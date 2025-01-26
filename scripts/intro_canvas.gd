# --
# credits canvas

extends CanvasLayer

# signals
signal end_intro

# refs
#@onready var buttons = $buttons


func _ready() -> void:
	pass
	# connect signals
	#buttons.get_node("end").button_up.connect(self._on_exit_button_up)


func _process(_delta:float) -> void:
	
	# active check
	if not self.visible: return

	# escape and end game
	if Input.is_action_just_pressed("escape") or Input.is_action_just_pressed("interact"): 
		$auto_exit.stop();
		end_intro.emit()





func _on_auto_exit_timeout() -> void:
	end_intro.emit()
