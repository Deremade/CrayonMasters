class_name Collectable extends Interactiable
# Class: Collectable
# Extends: Interactiable
# Description: Item that can be placed on the map and collected by characters
#
# Properties:
#   - item_name: String - name of the item
#
# Signals:
#   - signal_name(param): Description of when signal is emitted
#
# Dependencies:
#   - Character : add_resource #Not yet Implemented
#
# Usage Notes:
#   - NOT TESTED OR FINISHED YET

@export var item_name: String  # e.g., "health", "gold"

# Function: interact
# Description: Function not Finsihed (FNF)
# Parameters: 
#   - character: Character - Description of parameter
#   - param2: Type - Description of parameter
# Returns: void
# Dependencies: FNF
# Side Effects: activates queue_free()
# Uses :
#   -Nowhere (FNF)
#
# Modification Guidelines:
#   - FNF
func interact(character: Character) -> void:
	# Example: Grant the character some resource and remove the collectable
	character.add_resource(item_name)
	queue_free()
