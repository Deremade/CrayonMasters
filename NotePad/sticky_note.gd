extends ColorRect

signal select_option
var ability : Ability
var using_ability_callable = Callable(self, "using_ability")


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
	ability.use_ability.connect(using_ability_callable)
	select_option.emit(0, ability)
	$Main/Use.visible = false
	$Main/Cancel.visible = true
	pass # Replace with function body.

func _on_cancel_pressed():
	if(ability.use_ability.is_connected(using_ability_callable)):
		ability.use_ability.disconnect(using_ability_callable)
	select_option.emit(-1, ability)
	$Main/Use.visible = true
	$Main/Cancel.visible = false
	$Main/Confirm.visible = false
	pass # Replace with function body.

func using_new_ability(used_ability):
	if(used_ability != ability):
		_on_cancel_pressed()

func _on_confirm_pressed():
	select_option.emit(1, ability)
	$Main/Use.visible = true
	$Main/Cancel.visible = false
	$Main/Confirm.visible = false
	pass # Replace with function body.

func using_ability():
	$Main/Confirm.visible = true
