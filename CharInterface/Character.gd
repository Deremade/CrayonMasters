class_name Character extends Resource

#Basic
@export var char_name : String
#Profile Picture
@export var hat_pic : Texture
	#Some pictures pointto the left or right by default
@export var base_oritentation : bool
@export var inventory : Array[Ability]
@export var abiltiies : Array[Ability]
#Base Stats
var strength = 3
var reflexes = 3
var charisma = 3
var intelligance = 3
signal signal_damage()
var health = 20 :
	set(hp):
		var dmg = health-hp
		health = hp
		signal_damage.emit(dmg)

var effects = []

func take_damage(amount):
	health -= amount
