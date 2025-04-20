extends Container
var TabNode : PackedScene = load("res://NoteCard/tab.tscn")
var xpand_data = {
	"Inventory" : [Ability.new("Melee Weapon", 1), Ability.new("Ranged Weapon", 10), Ability.new("Health Potion", 1)],
	"Abilities" : ["Dash", "Fire"],
	"Fire" : ["FireBall", "FireWall", "Light Fire"]
}
var selected : MapItem = null
var cols = {
	0 : [],
	1 : [],
	2 : []
}
var is_targeting = false

func _ready():
	$Button.position = Vector2(225, 0)

func move(button_pressed):
	selected.is_moving = button_pressed

func select_interact(button_pressed):
	is_targeting = true
	for i in selected.get_interactables(1):
		i.player_targeted(true)

func add_item(item_name, col, row):
	var newTab = TabNode.instantiate()
	if xpand_data.has(item_name):
		newTab.set_tab_vars(item_name, true, xpand_data[item_name])
	else :
		newTab.set_tab_vars(item_name, false, [])
	newTab.position = Vector2i(96*col, 32+(32*row))
	newTab.connect("expand", on_expand.bind(col+1))
	newTab.connect("check", on_check)
	
	add_child(newTab)
	cols[col].append(newTab)


func _on_notebook_select_map_item(item):
	if is_targeting:
		if(item.can_target()):
			if(item is Character):
				selected.use_ability(item)
			if(item is Interactiable):
				selected.interact(item)
		return
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

func on_check(data, pressed):
	print(data, "  ", pressed)
	if(not data is Ability):
		if(data == "Move"):
			move(pressed)
		if(data == "Interact"):
			select_interact(pressed)
	else :
		is_targeting = pressed
		if(is_targeting):
			selected.player_selects_ability(data)
		else :
			selected.player_deselects_ability()

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
	is_targeting = false
	if is_turn:
		add_item("Move", 0, 0)
		add_item("Interact", 0, 1)
		add_item("Inventory", 0, 2)
		add_item("Abilities", 0, 3)

func _on_button_pressed():
	selected.is_turn = false
	pass # Replace with function body.
