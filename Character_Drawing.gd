extends Node2D

@export var character : Character
@export var facing_right : bool = false

signal using_ability(toggled : bool, ability : Ability, char : Character)
signal target(char : Character)


func _ready():
	$Pic.texture = character.profile_pic
	$NameTag.text = character.char_name
	$NotePad.set_char(character)
	if(character.base_oritentation):
		if(!facing_right) : $Pic.scale.x = -1
	else:
		if(facing_right): $Pic.scale.x = -1


func _on_note_pad_using_ability(toggle, ability):
	using_ability.emit(toggle, ability, character)
	pass # Replace with function body.


func _on_target_char_pressed():
	target.emit(character)
	pass # Replace with function body.


func _on_battle_player_targeting(is_targeting):
	$Target_Char.visible = is_targeting

func change_turn(is_now_turn : bool):
	$Turn_Indicator.visible = is_now_turn
	if(is_now_turn):
		character.start_turn()
		return
	character.end_turn()
