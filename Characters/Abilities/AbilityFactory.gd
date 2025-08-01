class_name AbilityFactory
static var type = 2

static func Melee(name, med, dev):
	var melee_weapon = DamageAbility.new(name, 1)
	melee_weapon.set_dmg(type, med, dev)
	return melee_weapon

static func Projectile(name, reach, med, dev):
	var ranged_weapon = DamageAbility.new(name, reach)
	ranged_weapon.set_dmg(type, med, dev)
	return ranged_weapon

static func Blast(name, reach, range, med, dev):
	var blast_ability = DamageAbility.new(name, reach, range)
	blast_ability.set_dmg(type, med, dev)
	return blast_ability
