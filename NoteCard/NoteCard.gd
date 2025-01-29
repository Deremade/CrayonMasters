extends Container
signal toggle_movement
var TabNode : PackedScene = load("res://NoteCard/tab.tscn")
var xpand_data = {
	"Inventory" : ["Melee Weapon", "Rangd Weapon", "Health Potion"],
	"Abilities" : ["Dash", "Fire"],
	"Fire" : ["FireBall", "FireWall", "Light Fire"]
}
var cols = {
	0 : [],
	1 : [],
	2 : []
}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_item("Move", 0, 0)
	add_item("Inventory", 0, 1)
	add_item("Abilities", 0, 2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func move(button_pressed):
	toggle_movement.emit(button_pressed)

func add_item(name, col, row):
	var newTab = TabNode.instantiate()
	if xpand_data.has(name):
		newTab.set_tab_vars(name, true, xpand_data[name])
	else :
		newTab.set_tab_vars(name, false, [])
	newTab.position = Vector2i(96*col, 32+(32*row))
	newTab.connect("expand", on_expand.bind(col+1))
	newTab.connect("select", on_select)
	add_child(newTab)
	cols[col].append(newTab)


func _on_notebook_select_map_item(item):
	$RichTextLabel.text = item.char_name
	print(item.char_name)

func on_expand(data, col):
	var row = 0
	clear_col(col)
	for d in data:
		add_item(d, col, row)
		row += 1

func on_select(data, pressed):
	print(data, "  ", pressed)
	move(pressed)

func clear_col(num):
	if(not cols.has(num)):
		return
	clear_col(num+1)
	for item in cols[num]:
		remove_child(item)
	cols[num] = []
