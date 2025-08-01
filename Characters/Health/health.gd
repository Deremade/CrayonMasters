class_name Health extends Resource

# Class: Health
# Extends: Resource
# Description: Contains all HitPoint / Character Health information
#
# Properties:
#   - hearts: int - How many "Hearts" they have
#   - hp: int - How many hit points they have
#   - max_ hp: int - how many hit points they can have
#   - anatomy : Body- contains all information about the anatomy
#
# Static Properties:
#   - body: bool - Wheather or not the Anatomy is used
#   - hit_points: bool - Wheater or not hit points are used (falsse means using injuries or hearts)
#
# Dependencies:
#   - Body class
#   - List required autoloads
#
# Usage Notes:
#   - Referances anatomy for Body when body is used
#   - Remember : there are 4 differnt "Health modes" using the static varibales to indicate which one is used
# TODO :
#	- make loadingt he body more efficient
#	- connect defeat() with anatomy

# Hearts (for non-body non-hit points)
var hearts = 3 : set = change_hearts
# Hit points
var hp = 10 : set = change_hp
var max_hp = 10 
# Anatomy
var anatomy = Body.new()

signal change_health

#Use the anatomy or not
static var body : bool = false : set = swtich_body
#Use it points or not
static var hit_points : bool = true : set = switch_hp


func _init():
	anatomy.change_functionality.connect(func() : if(anatomy.functionality <= 0) : defeat())

# Function: dmg
# Description: The character takes damage
# Parameters:
#   - amount: int - amount of damage
# Returns: void
# Dependencies: none
# Side Effects: changes anatomy, hearts, hit_points
# Example Usage:
#   health.dmg(randi() % 10)
# Uses :
#   -use_ability_on_char : Ability.gd
#
# Modification Guidelines:
#   - 10 damage ~= max health
func dmg(amount : int):
	print("Take ", amount, " damage")
	if body :
		anatomy.injur(amount)
		change_health.emit()
		return
	if hit_points :
		hp -= amount
		change_health.emit()
		return
	hearts -= ceil(float(amount)/3)
	change_health.emit()

#### SET FUNCTIONS ####
static func swtich_body(use_body : bool):
	body = use_body
	pass

static func switch_hp(use_hp : bool):
	hit_points = use_hp
	pass

func change_hearts(h):
	if h <= 0 :
		defeat()
	hearts = h

func change_hp(h):
	if h <= 0 :
		defeat()
	hp = h

### End set Functions ###

func defeat():
	print("Defeated")
	pass

func _to_string():
	if(body):
		return str(anatomy)
	else:
		if hit_points:
			return "HP : " + str(hp) + "\\" + str(max_hp)
		else :
			var heart_dispaly = "Hearts: "
			for i in hearts :
				heart_dispaly += "X"
			return heart_dispaly
