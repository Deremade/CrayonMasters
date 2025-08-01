extends ColorRect

var sticky_note = preload("res://NotePad/sticky_note.tscn")
var item_index = 0
var ability_index = 0
signal select_new_ability

func _ready():
	$Main/CharName.text = get_parent().char_name
	$Main/StickNote.set_ability(AbilityFactory.Melee("Sword", 5, 2))
	select_new_ability.connect(Callable($Main/StickNote, "using_new_ability"))
	$Main/StickNote2.set_ability(AbilityFactory.Projectile("Bow", 6, 5, 5))
	select_new_ability.connect(Callable($Main/StickNote2, "using_new_ability"))
	$Main/StickNote3.set_ability(AbilityFactory.Blast("FireBall", 6, 2, 7, 5))
	select_new_ability.connect(Callable($Main/StickNote3, "using_new_ability"))
	
	get_parent().health.change_health.connect(Callable(self, "update_health"))
	update_health()

func update_health():
	$Main/Health/Button.visible = Health.body
	if(not Health.body):
		$Main/Health.text = str(get_parent().health)
	else :
		$Main/Health.text = "Health"

func _on_button_toggled(button_pressed):
	get_parent().is_moving = button_pressed


func _on_close_pressed():
	visible = false

func add_inventory(item : Ability):
	var new_sticky = sticky_note.instantiate()
	new_sticky.set_ability(item)
	new_sticky.position = Vector2(0, 32)
	new_sticky.select_option.connect(Callable(self, "select_option"))
	select_new_ability.connect(Callable(new_sticky, "using_new_ability"))
	$Inventory.add_child(new_sticky)

func add_ability(item : Ability):
	var new_sticky = sticky_note.instantiate()
	new_sticky.set_ability(item)
	new_sticky.position = Vector2(( (item_index % 3) * 100)-16, floor(item_index/3)*100+32)
	item_index += 1
	new_sticky.select_option.connect(Callable(self, "select_option"))
	select_new_ability.connect(Callable(new_sticky, "using_new_ability"))
	$Abiltiies.add_child(new_sticky)


func _on_inventory_pressed():
	$Main.visible = false
	$Inventory.visible = true


func _on_end_turn():
	get_parent().is_turn = false


func _on_character_change_turn(is_turn):
	$Main/Move.visible = is_turn
	$Main/Endturn.visible = is_turn


func _on_abilities_pressed():
	$Main.visible = false
	$Abiltiies.visible = true


func _on_back_pressed():
	$Main.visible = true
	$Inventory.visible = false
	$Abiltiies.visible = false

func select_option(option : int, ability : Ability):
	match option:
		-1:
			get_parent().player_deselects_ability()
		0: 
			select_new_ability.emit(ability)
			get_parent().player_selects_ability(ability)
		1:
			get_parent().execute_ability()
		_:
			pass


func _on_health_pressed():
	print(get_parent().health)
