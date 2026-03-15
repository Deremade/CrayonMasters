class_name WrittenText extends RichTextLabel
var is_writting = false
var queue = []
signal finish_writting

func type_text(st_text: String, speed: float = 0.05):
	if(is_writting):
		queue.append(set_text)
		return
	is_writting = true
	text = st_text  # Set full text (with BBCode)
	visible_characters = 0

	var total_chars = get_total_character_count()

	while visible_characters < total_chars:
		visible_characters += 1
		await get_tree().create_timer(speed).timeout
	is_writting = false
	
	if(len(queue) > 0):
		await get_tree().create_timer(1).timeout
		if(len(queue) == 0):
			return
		await type_text(queue.pop_front())
	finish_writting.emit()
