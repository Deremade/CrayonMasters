class_name Character extends Resource

#Basic
@export var char_name : String
#Profile Picture
@export var profile_pic : Texture
	#Some pictures pointto the left or right by default
@export var base_oritentation : bool
@export var inventory : Array[Ability]
var actions = 1
#Base Stats
var strength = 3
var reflexes = 3
var charisma = 3
var intelligance = 3
var health = 20

var effects = []

func use_ability(ability : Ability, target: Character):
	ability.use(self, target)
	actions -= 1

func take_damage(amount):
	health -= amount
	print(char_name, " has ", health, " hp left")

func start_turn():
	actions = 1
	for e in effects :
		e.start_turn_effect(self)

func end_turn():
	for e in effects :
		e.end_turn_effect()
		if (e.stacks == 0):
			effects.remove_at(effects.find(e))
	print(len(effects))
