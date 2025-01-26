# --
# wizard fight world

extends Node2D

# signals
signal fight_is_now_over_go_up
signal fight_is_now_over_but_you_lost

# refs
@onready var wizard = $wizard
@onready var character_fighter = $character_fighter


func overwrite_character_stats(new_stats):

	# overwrite wizard stats
	character_fighter.set_character_stats(new_stats)


# --
# signal methods

func _on_wizard_the_evil_wizard_is_dead() -> void:
	fight_is_now_over_go_up.emit()


func _on_character_fighter_the_poor_character_died_during_an_epic_fight() -> void:
	fight_is_now_over_but_you_lost.emit()
