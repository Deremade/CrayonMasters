extends Container
var TabNode : PackedScene = load("res://NoteCard/tab.tscn")
var xpand_data = {
	"Inventory" : ["Melee Weapon", "Rangd Weapon", "Health Potion"],
	"Abilities" : ["Dash", "Fire"],
	"Fire" : ["FireBall", "FireWall", "Light Fire"]
}
var selected : MapItem = null
var cols = {
	0 : [],
	1 : [],
	2 : []
}

func _ready():
	$Button.position = Vector2(225, 0)

func move(button_pressed):
	selected.is_moving = button_pressed

func add_item(item_name, col, row):
	var newTab = TabNode.instantiate()
	if xpand_data.has(item_name):
		newTab.set_tab_vars(item_name, true, xpand_data[item_name])
	else :
		newTab.set_tab_vars(item_name, false, [])
	newTab.position = Vector2i(96*col, 32+(32*row))
	newTab.connect("expand", on_expand.bind(col+1))
	newTab.connect("select", on_select)
	add_child(newTab)
	cols[col].append(newTab)


func _on_notebook_select_map_item(item):
	if selected != null :
		selected.change_turn.disconnect(turn_operations)
	selected = item
	selected.change_turn.connect(turn_operations)
	turn_operations(selected.is_turn)
	$RichTextLabel.text = item.char_name

func on_expand(data, col):
	var row = 0
	clear_col(col)
	for d in data:
		add_item(d, col, row)
		row += 1

func on_select(data, pressed):
	print(data, "  ", pressed)
	if(data == "Move"):
		move(pressed)

func clear_col(num):
	if(not cols.has(num)):
		return
	clear_col(num+1)
	for item in cols[num]:
		remove_child(item)
	cols[num] = []

func turn_operations(is_turn):
	clear_col(0)
	$Button.visible = is_turn
	if is_turn:
		add_item("Move", 0, 0)
		add_item("Inventory", 0, 1)
		add_item("Abilities", 0, 2)

func _on_button_pressed():
	selected.is_turn = false
	pass # Replace with function body.
