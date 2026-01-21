class_name DamageAbility extends Ability

@export var dmg : int
@export var add_effects : Array[statEffect]

func _init(ability_name, png_file, set_dmg  : int = 5, effects : Array[statEffect] = []) -> void:
	super._init(ability_name, png_file)
	dmg = set_dmg
	add_effects = effects
	
func use(_actor : Character, target : Character):
	target.take_damage(dmg)
	for e in add_effects:
		target.effects.append(e)
