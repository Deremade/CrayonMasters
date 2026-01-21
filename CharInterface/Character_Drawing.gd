class_name CharacterDrawing extends Node2D

@export var character : Character
@export var team : int
@export var NPC : bool
var actions = 1
signal char_death

signal using_ability(toggled : bool, ability : Ability, char : Character)
signal target(char : Character)


func _ready():
	$Head/Hat.texture = character.hat_pic
	$Head/Hat.modulate = character.hat_color
	$NameTag.text = character.char_name
	$NotePad.set_char(character)
	character.signal_damage.connect(Callable(self, "check_hp"))


func _on_note_pad_using_ability(toggle, ability):
	using_ability.emit(toggle, ability, self)
	pass # Replace with function body.


func _on_target_char_pressed():
	target.emit(character)
	pass # Replace with function body.


func _on_battle_player_targeting(is_targeting):
	$Target_Char.visible = is_targeting

func change_turn(is_now_turn : bool):
	$Turn_Indicator.visible = is_now_turn
	if(is_now_turn):
		start_turn()
	end_turn()
	if($NotePad/Abilities.has_node("StickyNote")) :
		$NotePad/Abilities/StickyNote/CheckBox.button_pressed = false
	if($NotePad/Inventory.has_node("StickyNote")) :
		$NotePad/Inventory/StickyNote/CheckBox.button_pressed = false

func check_hp(dmg):
	if character.health <= 0:
		char_death.emit(self)
		queue_free()
		if($Turn_Indicator.visible):
			character.end_turn()
	await status_message("-"+str(dmg)+" HP : " + str(character.health))

func status_message(text):
	await $WrittenText.type_text(text)
	await get_tree().create_timer(1).timeout
	$WrittenText.type_text("")

func start_turn():
	actions = 1
	for e in character.effects :
		e.start_turn_graphic(self)
		e.start_turn_effect(character)

func end_turn():
	for e in character.effects :
		e.end_turn_effect()
		if (e.stacks == 0):
			character.effects.remove_at(character.effects.find(e))

func use_ability(ability : Ability, ability_target: Character):
	ability.use(character, ability_target)
	actions -= 1

func _to_string() -> String:
	return str(character)
