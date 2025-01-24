# --
# title canvas

extends CanvasLayer

# signals
signal start_game
signal end_game
signal credits

# refs
@onready var buttons = $buttons


func _ready() -> void:

	# connect signals
	buttons.get_node("start").button_up.connect(self._on_start_button_up)
	buttons.get_node("credits").button_up.connect(self._on_credits_button_up)
	buttons.get_node("end").button_up.connect(self._on_end_button_up)


# --
# buttons

func _on_start_button_up(): start_game.emit()
func _on_credits_button_up(): credits.emit()
func _on_end_button_up(): end_game.emit()
