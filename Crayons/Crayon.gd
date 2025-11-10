extends Node2D

@export var color : Color
@export var text : String
var hovered = false
var selected = false
# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.y = -20
	$Control/Polygon2D.color = color
	$Control/ColorRect.color = color
	$Control/RichTextLabel.text = "[b]"+text+"[/b]"
	$New_Mouse.color = color
	if(color == Color.BLACK):
		$Control/ColorRect2.color = Color.WHITE
		$Control/RichTextLabel.add_theme_color_override("default_color", Color.WHITE)


func _on_area_2d_mouse_entered():
	$Control.position.y = -100
	hovered= true

func _on_area_2d_mouse_exited():
	$Control.position.y = 0
	hovered = false

func _input(event):
	if(!hovered): return
	if event is InputEventMouseButton and event.pressed:
		selected = !selected
		$New_Mouse.visible = selected
		if(selected):
			var new_cursor : Texture= load("res://FTMenuPeice.png")
			Input.set_custom_mouse_cursor(new_cursor)
		else :
			Input.set_custom_mouse_cursor(null)
