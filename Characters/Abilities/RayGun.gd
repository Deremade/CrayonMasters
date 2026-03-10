class_name RayGun extends Ability
#Raygin Test Ability

func _init():
	#Define possible user choies and setting
	settings = {"Setting" = ["Stun", "Heat Ray", "Disintigrate"],
				"Power" = [0, 10]}

func use(_actor : Character, target : Character):
	#Read user deffined settings
	match changes.get("Setting"):
		"Stun" : target.effects.append(statEffect.Stun.new())
		"Heat Ray" : target.take_damage(changes.get("Power"))
		"Disintigrate" : target.take_damage(changes.get("Power"))
		_ : Game.err_sticker("Gun not set", null)
