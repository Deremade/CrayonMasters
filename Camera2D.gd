extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if(Input.is_action_pressed("ui_up")):
		position.y -= 10
	if(Input.is_action_pressed("ui_down")):
		position.y += 10
	if(Input.is_action_pressed("ui_left")):
		position.x -= 10
	if(Input.is_action_pressed("ui_right")):
		position.x += 10


func _on_notebook_change_turn(turn):
	print("Cur turn is : ", turn)
