class_name RayGun extends Ability
	
func _init():
	settings = {"Setting" = ["Stun", "Heat Ray", "Disintigrate"],
				"Power" = [0, 10]}
	
func use(_actor : Character, target : Character):
	match changes.get("Setting"):
		"Stun" : target.effects.append(statEffect.Stun.new())
		"Heat Ray" : target.take_damage(changes.get("Power"))
		"Disintigrate" : target.take_damage(changes.get("Power"))
		_ : print("Gun not set")
