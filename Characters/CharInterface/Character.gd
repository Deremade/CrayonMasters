class_name Character extends Resource

#Basic
@export var char_name : String
#Profile Picture
@export var hat_pic : Texture
@export var hat_color : Color
@export var inventory : Array[Ability]
@export var abiltiies : Array[Ability]
#Base Stats
var strength = 3
var reflexes = 3
var charisma = 3
var intelligance = 3
#Signal that emits when the character takes dmaage
#Connects to note_pad.gd : update_health
#Connects to Character_Drawing : check_hp
signal signal_damage()
#Health has a setter function that emits the signal_damage signal
var health = 20 :
	set(hp):
		var dmg = health-hp
		health = hp
		signal_damage.emit(dmg)
#The current effects affecting the character [see effect.gd]
var effects = []
#Function to take damage
func take_damage(amount):
	health -= amount
#Builds a character from a dictionary of settings
#Inovked in adventure_characters.gd : _on_button_pressed
func build_from_settings(settings):
	hat_pic = settings["Hat"]
	hat_color = settings["Hat Color"]
	#Inventory
	inventory = []
	if(settings["Sword"]):
		inventory.append(DamageAbility.new("Sword", "res://Sprites/ItemImgs/ComfyUI_temp_umxzz_00003_.png"))
	if(settings["Raygun"]):
		inventory.append(load("res://TestScaffolds/TestCharacters/raygun.tres"))
	if(settings["Pistol"]):
		inventory.append(DamageAbility.new("Pistol", "res://Sprites/ItemImgs/ComfyUI_temp_bthta_00016_.png"))
	if(settings["Shirkien"]):
		inventory.append(DamageAbility.new("Shirkien", "res://Sprites/ItemImgs/ComfyUI_temp_ryfff_00001_.png", 3, [Poison.new()]))
	#Abilities
	abiltiies = []
	if(settings["Freeze"]):
		abiltiies.append(DamageAbility.new("Freeze", "res://Sprites/ItemImgs/ComfyUI_temp_adpkh_00001_.png", 0, [Frozen.new()]))
	if(settings["Fireball"]):
		abiltiies.append(DamageAbility.new("Fireball", "res://Sprites/ItemImgs/ComfyUI_temp_bthta_00039_.png", 10))
	if(settings["Lightning"]):
		abiltiies.append(DamageAbility.new("Lightning", "res://Sprites/ItemImgs/ComfyUI_temp_aednp_00001_.png", 5, [statEffect.Stun.new()]))

func _to_string() -> String:
	return char_name
