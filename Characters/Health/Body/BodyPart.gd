class_name BodyPart extends Resource

# Class: BodyPart
# Extends: Resource
# Description: Represents a single part of the character's body
#
# Properties:
#   - name: String - The name of the body part
#   - functionality: float - Desribes how well the part (or system) is functioning
#   - health: int - How many hit points the part has
#   - injuries: Array<int> - How many of each level injury they have [0] = level 1 injuries, [1] = level 2 injuries etc.
#   - injury_level: int - Current Max injury level
#
# Signals:
#   - change_functionality(): emitted when the functionality variable changes
#
# Dependencies:
#   - Health.gd has static variable : hit_points
#
# Usage Notes:
#   - Is the building block for BodySystem
#   - 1 level 1 injury ~= 0.042 hp damage
#   - May want to expand types of injuries

var name : String
var functionality : float = 1
signal change_functionality

#Health points
var health : int = 10
#Injury system
#Each array element is an injury of that level
var injuries = [0, 0, 0, 0]
var injury_level = 0


func _init(set_bp_name : String):
	name = set_bp_name

func _to_string():
	return name + " " + str(round(functionality*100)) + "%"

# Function: injur
# Description: adds an injury or damage
# Parameters:
#   - amount: number - Amount of Damage
#   	-every 3pts is 1 level of injury
# Returns: none
# Dependencies: Health.hit_points
#				injuries[]
# Side Effects: Activates : clac_injury_level() and calc_functionality()
# Example Usage:
#   anatomy.injur(amount)
# Uses :
#   -BodySystem.gd  : injur() 
#   -Health.gd : dmg
#
# Modification Guidelines:
#   - Depends on the hit_points varibale in Health (static varibale)
#   - 1 level 1 injury ~= 0.042 hp damage
func injur(amount):
	#If hit points are active deal damage directly to health
	if Health.hit_points:
		health = round(health - amount)
	#Otherwise add injury
	else :
		print(" ... ",amount * 0.3)
		var mod_amount = min(ceil(amount * 0.3), 4)-1
		injuries[mod_amount] += 1
		clac_injury_level()
	#Once damage si done, calculate functionality
	calc_functionality()

# Function: clac_injury_level
# Description: Calculates the injury level
# Returns: void
# Dependencies: injuries
# Side Effects: changes the injury_level varibale
# Uses :
#   -injur() (this file)
#
# Modification Guidelines:
#   - This function changes injury_level, does not return anything
func clac_injury_level():
	var mod_injuries = [] + injuries
	#4 Level 1 injuries : 1 level 2 injury
	if mod_injuries[0] >= 4 :
		mod_injuries[1] += floor(mod_injuries[0]/4)
	#3 Level 2 injuries : 1 level 3 injury
	if mod_injuries[1] >= 3 :
		mod_injuries[2] += floor(mod_injuries[1]/3)
	#2 Level 3 injuries : 1 level 4 injury
	if mod_injuries[2] >= 2 :
		mod_injuries[3] += floor(mod_injuries[2]/2)
	var injlevel = 0
	#Find the hihgest injury level with at least 1 injury
	for i in range(0, 4):
		if mod_injuries[i] != 0:
			injlevel = i+1
	injury_level = injlevel

# Function: calc_functionality
# Description: Caculates the functionality variable
# Returns: void
# Dependencies: none
# Side Effects: chnges the functionality variable
#			emits "change_functionality" signal
# Uses :
#   -injur() : This File
@warning_ignore("integer_division")
func calc_functionality():
	#If hit_pointd is active, functionality is proportional to health
	if Health.hit_points :
		functionality = health/10
	else :
		#If max injury level : part si sdestoryed
		if(injury_level == 4) : 
			functionality = 0
			change_functionality.emit()
			return
		#start at full functionality, lose functionality for each injury
		var function = 1
		function -= injuries[2] * (0.5)
		function -= injuries[1] * (0.166)
		function -= injuries[0] * (0.042)
		functionality = function
	change_functionality.emit()
