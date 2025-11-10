class_name Poison extends statEffect
@export var dmg : int

func start_turn_effect(charactr : Character):
	charactr.take_damage(dmg)
