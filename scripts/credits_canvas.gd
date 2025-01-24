# --
# credits canvas

extends CanvasLayer

# signals
signal end_credits

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
	if Input.is_action_just_pressed("escape") or Input.is_action_just_pressed("interact"): end_credits.emit()


func _on_exit_button_up() -> void:
	end_credits.emit()
