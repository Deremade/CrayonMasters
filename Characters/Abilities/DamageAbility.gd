class_name DamageAbility extends Ability

# 0 : Static, 1 : Range, 2 : Gaussian
var dmg_type = 0
var median
var dev

func set_dmg(set_type, set_median, set_dev):
	dmg_type = set_type
	median = set_median
	dev = set_dev

func use_ability_on_char(_char : Character):
	match dmg_type:
		0 : _char.dmg(median)
		1 : _char.dmg(median - (dev/2) + (randi() % dev))
		2 : _char.dmg(max(0, randfn(median, dev)))
