class_name Body extends BodySystem

# Class: Body
# Extends: BodySystem
# Description: Acts as a Human Body BodySystem
#
# Usage Notes:
#   - only represents the human body

func _init():
	super("Body")
	#Manipulation
	var Manipulation = BodySystem.new("Manipulation")
	var left_arm = build_arm("Left")
	var right_arm = build_arm("Right")
	Manipulation.add_part(left_arm)
	Manipulation.add_part(right_arm)
	#Movement
	var Movement = BodySystem.new("Movment")
	var left_leg = build_leg("Left")
	var right_leg = build_leg("Right")
	Movement.add_part(left_leg)
	Movement.add_part(right_leg)
	#Circulation
	var Circulation = BodySystem.new("Circulation")
	Circulation.add_part(BodyPart.new("Heart"), 2)
	Circulation.add_part(BodyPart.new("Lungs"))
	#Sensing
	var Sensing = BodySystem.new("Sensing")
	Sensing.add_part(BodyPart.new("Left Eye"), 3, false)
	Sensing.add_part(BodyPart.new("Right Eye"), 3, false)
	Sensing.add_part(BodyPart.new("Left Ear"), 1, false)
	Sensing.add_part(BodyPart.new("Right Ear"), 1, false)
	#Cognition
	var Brain = BodyPart.new("Brain")
	#Connecting Body Parts
	add_part(Circulation, 2)
	add_part(Manipulation, 1, false)
	add_part(Movement, 1, false)
	add_part(Sensing, 1, false)
	add_part(Brain, 5)
	pass

func build_arm(title : String):
	var new_arm = BodySystem.new(title + " Arm")
	new_arm.add_part(BodyPart.new(title + " Shoulder"))
	new_arm.add_part(BodyPart.new(title + " Upper Arm"))
	new_arm.add_part(BodyPart.new(title + " Lower Arm"))
	new_arm.add_part(BodyPart.new(title + " Hand"), 2)
	return new_arm

func build_leg(title : String):
	var new_leg = BodySystem.new(title + " Leg")
	new_leg.add_part(BodyPart.new(title + " Thigh"))
	new_leg.add_part(BodyPart.new(title + " Kneee"))
	new_leg.add_part(BodyPart.new(title + " Lower Leg"))
	new_leg.add_part(BodyPart.new(title + " Foot"), 2)
	return new_leg
