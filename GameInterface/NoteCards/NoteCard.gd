class_name NoteCard extends Control

var changes = {}
signal made_changes #Singal connected in NoteCardButton

func _ready():
	pass
#Adding text to the next section of the notcard
func add_text(added_text : String):
	var new_text : RichTextLabel= RichTextLabel.new()
	new_text.text = added_text
	new_text.fit_content = true
	$ScrollContainer/Content.add_child(new_text)

func add_num_input(label, min_val = 0, max_val = 10, suffix = ""):
	#Initialize numerical input
	var new_num_input = SpinBox.new()
	new_num_input.prefix = label
	new_num_input.min_value = min_val
	new_num_input.max_value = max_val
	new_num_input.suffix = suffix
	new_num_input.focus_mode = Control.FOCUS_ALL
	#Connect signal
	new_num_input.value_changed.connect(
		func(new_value): 
			make_change(label, new_value)
			new_num_input.release_focus()
	)
	#Add to notecard
	$ScrollContainer/Content.add_child(new_num_input)
	changes[label] = min_val #Initialize the chnages as the lowest value

func add_dropdown(label : String, options):
	var h_box = HBoxContainer.new() #Create box for the dropdown
	#Create Label
	var draw_label = RichTextLabel.new()
	draw_label.text = label
	draw_label.custom_minimum_size = Vector2(128, 32)
	#Create the dropdown
	var new_dropdownbox : OptionButton = OptionButton.new()
	for option in options:
		if option is ImageTexture : #If image; paste image
			new_dropdownbox.add_icon_item(option, "")
		else : #If not image : Assume text
			new_dropdownbox.add_item(option)
	#Add to box
	h_box.add_child(draw_label)
	h_box.add_child(new_dropdownbox)
	#Add box to notecard
	$ScrollContainer/Content.add_child(h_box)
	#Connect change signal
	new_dropdownbox.item_selected.connect(func(index):
		make_change(label, options[index])
	)
	changes[label] = options[0] #Initialize changes to default option

func add_checkbox(label : String):
	#Initialize Checkbox
	var new_checkbox = CheckBox.new()
	new_checkbox.text = label
	#Connect change signal
	new_checkbox.toggled.connect(func(checked):
		make_change(label, checked)
	)
	$ScrollContainer/Content.add_child(new_checkbox)
	#Initialize changes to false
	changes[label] = false

func add_color_picker(label):
	#Initialze box and label
	var h_box = HBoxContainer.new()
	var draw_label = RichTextLabel.new()
	draw_label.text = label
	draw_label.custom_minimum_size = Vector2(128, 32)
	#Initialize the color picker
	var new_color_picker = ColorPickerButton.new()
	new_color_picker.text = "   --     --"
	#Connect chnage signal
	new_color_picker.color_changed.connect(func(color):
		make_change(label, color)
		)
	#add components to box
	h_box.add_child(draw_label)
	h_box.add_child(new_color_picker)
	changes[label] = new_color_picker.color #Initialize to default
	$ScrollContainer/Content.add_child(h_box)
	pass

func _on_close_pressed():
	self.visible = false

func make_change(label, change):
	changes[label] = change
	made_changes.emit(changes)

func clear_card():
	for c in $ScrollContainer/Content.get_children():
		$ScrollContainer/Content.remove_child(c)
