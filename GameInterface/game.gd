class_name Game extends Node2D

static var sticker = preload("res://Stylization/Err_Sticker.tscn")

#Creates a popup and adds it to the top node, positioning it by the mouse
static func err_sticker(err_message, node) :
	var Err_Sticker = sticker.instantiate()
	Err_Sticker.global_position  = node.get_local_mouse_position()
	node.add_child(Err_Sticker)
	Err_Sticker.update_box_size(err_message)
	Err_Sticker.z_index = RenderingServer.CANVAS_ITEM_Z_MAX
	return Err_Sticker
