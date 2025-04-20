class_name Interactiable extends MapItem

var is_solved: bool = false

func interact(character: Character) -> void:
	print("Interacted")
	if not is_solved:
		# Simple random pass/fail for now
		is_solved = randf() > 0.5
		if is_solved:
			emit_signal("interacted", self)
			# Example: Unlock something
