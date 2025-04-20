class_name MapItem extends Sprite2D

var grid_pos: Vector2i : set = set_grid_pos
@export var start_pos: Vector2i
signal interacted(mapItem)

func _ready():
	grid_pos = start_pos

func set_grid_pos(new_pos: Vector2i):
	grid_pos = new_pos
	position = (grid_pos * 64) + Vector2i(32, 32)

func player_targeted(is_target):
	$TargetCircle.visible = is_target

func can_target():
	return $TargetCircle.visible
