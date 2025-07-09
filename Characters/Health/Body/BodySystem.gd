class_name BodySystem extends BodyPart

# Class: BodySystem
# Extends: BodyPart
# Description: Bodily Syystem comprising of multiple Parts
#
# Properties:
#   - dependancies: Array - sub parts of the system
#   - dpendancy_weights: Array - matches weights with parts
#   - dependancy_vital: Array - whather or not  apart is absolutley vital

#Dependancies
var dependancies = []
var dpendancy_weights = []
var dependancy_vital = []

# Function: add_part
# Description: Adds a BodtyPart or BodySystem to the system
# Parameters:
#   - part: BodyPart - The Part or System being added
#   - dependancy_weight: int - Th wight od the part for functionality
#   - is_vital: bool - Weather the part is absolutely necessary
# Side Effects: emits 
# Example Usage:
#   Sensing.add_part(BodyPart.new("Left Eye"), 3, false)
# Uses :
#   -_ready() : Body.gd
func add_part(part : BodyPart, dependancy_weight = 1, is_vital = true):
		dependancies.append(part)
		dpendancy_weights.append(dependancy_weight)
		dependancy_vital.append(is_vital)
		part.change_functionality.connect(func(): calc_functionality())

# Function: calc_functionality
# Description: Overrides the calc_functionality in BodyPart to find harmonic mean fo all body parts
# Dependencies: dependancies, dpendancy_weights, dependancy_vital
# Side Effects: none
# Uses :
#   -activated when a part emits change_functionality signal (calc_functionality : BodyPart.gd)
#
# Modification Guidelines:
#   - Harmonic mean cannot handle 0s
func calc_functionality():
	var harm_mean_den = 0
	var weights = 0
	#For every body part
	for i in len(dependancies):
		var store_functionality = dependancies[i].functionality
		#If the part is vital and destoryed, functionality is 0
		if(dependancy_vital[i]):
			if store_functionality <= 0 :
				functionality = 0
				change_functionality.emit()
				return
		#Keep track fo harmonic mean
		harm_mean_den += dpendancy_weights[i]/max(store_functionality, 0.01)
		weights += dpendancy_weights[i]
	#Set functionality to the harmonic mean
	functionality = weights/harm_mean_den
	#Emit the signal to let everything else know how functional the system is
	change_functionality.emit()

# Function: injur
# Description: overrides injur() from BodyPart, adds an injury or damage to a random part
# Parameters:
#   - amount: number - Amount of Damage
#   	-every 3pts is 1 level of injury
# Returns: none
# Dependencies: dependancies
# Side Effects: Activates injur() from BodyPart.gd
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
	#Randomly select a part, damage that part
	var targeted = randi() % len(dependancies)
	dependancies[targeted].injur(amount)
	print_system()

func print_system(indent : int = 0):
	var tabs = ""
	for i in range(indent):
		tabs += "\t"
	print(tabs, self)
	for d in dependancies:
		print(tabs, "\t", d)
	
