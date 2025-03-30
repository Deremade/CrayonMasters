extends Control
signal expand
signal select
var expand_data = null
var text

func set_tab_vars(set_text, expandable = true, set_expand_data = null):
	$RichTextLabel.text = set_text
	$Button.visible = expandable
	$CheckBox.visible = not expandable
	expand_data = set_expand_data
	text = set_text

func _on_button_pressed():
	expand.emit(expand_data)


func _on_check_box_toggled(button_pressed):
	select.emit(text, button_pressed)
	pass # Replace with function body.
