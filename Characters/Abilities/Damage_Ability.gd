class_name DamageAbility extends Ability

#Damage dealt by the ability [Subject to change]
@export var dmg : int
#Effects are defeined in statEffect.gd
@export var add_effects : Array[statEffect]

#initialization relies of parent class intialization
func _init(ability_name, png_file, set_dmg  : int = 5, effects : Array[statEffect] = []) -> void:
	super._init(ability_name, png_file)
	dmg = set_dmg
	add_effects = effects
	
	#Default function defiend in Parent class
func use(_actor : Character, target : Character):
	target.take_damage(dmg)
	for e in add_effects:
		target.effects.append(e)
