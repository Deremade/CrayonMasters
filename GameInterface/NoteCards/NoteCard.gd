class_name NoteCard extends Control

var changes = {}

func _ready():
	pass

func add_text(add_text : String):
	var new_text : RichTextLabel= RichTextLabel.new()
	new_text.text = add_text
	new_text.fit_content = true
	$ScrollContainer/Content.add_child(new_text)

func add_num_input(label, min_val = 0, max_val = 10, suffix = ""):
	var new_num_input = SpinBox.new()
	new_num_input.prefix = label
	new_num_input.min_value = min_val
	new_num_input.max_value = max_val
	new_num_input.suffix = suffix
	new_num_input.focus_mode = Control.FOCUS_ALL
	new_num_input.value_changed.connect(
		func(new_value): 
			make_change(label, new_value)
			new_num_input.release_focus()
	)
	$ScrollContainer/Content.add_child(new_num_input)
	changes[label] = min_val

func add_dropdown(label : String, options):
	var h_box = HBoxContainer.new()
	var draw_label = RichTextLabel.new()
	draw_label.text = label
	draw_label.custom_minimum_size = Vector2(128, 32)
	var new_dropdownbox : OptionButton = OptionButton.new()
	for option in options:
		new_dropdownbox.add_item(option)
	h_box.add_child(draw_label)
	h_box.add_child(new_dropdownbox)
	new_dropdownbox.item_selected.connect(func(index):
		make_change(label, options[index])
	)
	$ScrollContainer/Content.add_child(h_box)
	changes[label] = options[0]

func add_checkbox(label : String):
	var new_checkbox = CheckBox.new()
	new_checkbox.text = label
	new_checkbox.toggled.connect(func(checked):
		make_change(label, checked)
	)
	$ScrollContainer/Content.add_child(new_checkbox)
	changes[label] = false

func _on_close_pressed():
	self.visible = false

func make_change(label, change):
	changes[label] = change
