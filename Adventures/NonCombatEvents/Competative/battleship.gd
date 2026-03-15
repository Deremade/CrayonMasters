extends Event
var num_players
var board_size: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

class battleship_player:
	var board
	var num

	func _init(board_size:Vector2i, num_players:int) -> void:
		for i in range(board_size.x):
			var row = []
			for j in range(board_size.y):
				var tile = []
				for k in range(num_players):
					tile.append(0)
				row.append(tile)
			board.append(row)

	func did_hit(pos:Vector2i) -> bool:
		return board[pos.x][pos.y][num] == 1

	func attack(pos:Vector2i, target:battleship_player):
		board[pos.x][pos.y][target.num] == 1 if target.did_hit(pos) else -1
