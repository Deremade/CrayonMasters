class_name Game extends Node2D

static var sticker = preload("res://Stylization/Err_Sticker.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#Creates a popup and adds it to the top node, positioning it by the mouse
static func err_sticker(err_message, node) :
	var Err_Sticker = sticker.instantiate()
	Err_Sticker.position  = node.get_viewport().get_mouse_position()
	node.add_child(Err_Sticker)
	Err_Sticker.update_box_size(err_message)
	return Err_Sticker
