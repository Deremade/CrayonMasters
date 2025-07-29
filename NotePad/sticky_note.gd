extends ColorRect

signal select_option
var ability : Ability


func _on_info_pressed():
	$Opening.visible = true
	$Main.visible = false


func _on_close_sn_pressed():
	$Opening.visible = false
	$Main.visible = true

func set_ability(a : Ability):
	$Main/ItemName.text = a.name
	ability = a


func _on_use_pressed():
	select_option.emit(0, ability)
	pass # Replace with function body.
