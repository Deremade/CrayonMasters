class_name Collectable extends MapItem

@export var item_type: String  # e.g., "health", "gold"
@export var value: int = 1

func interact(character: Character) -> void:
	# Example: Grant the character some resource and remove the collectable
	character.add_resource(item_type, value)
	queue_free()
	emit_signal("interacted", self)
