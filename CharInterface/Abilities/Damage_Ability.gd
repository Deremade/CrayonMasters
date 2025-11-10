class_name DamageAbility extends Ability

@export var dmg : int
@export var add_effects : Array[statEffect]
	
func use(_actor : Character, target : Character):
	target.take_damage(dmg)
	for e in add_effects:
		target.effects.append(e)
