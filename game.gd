extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var theme = load("res://Style.theme")
	theme.set_default_font(load("res://Fonts/Pencilant Script.ttf"))
