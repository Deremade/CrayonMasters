extends Control

# Padding around the text (in pixels)
var padding = Vector2(50, 20)

func _ready():
	rotation = (randf() *2)-1
	await get_tree().process_frame

func update_box_size(message):
	# Get the content size of the RichTextLabel
	var text_size = get_theme_font("default_font").get_string_size(message)
	
	# Calculate the total size including padding
	var box_size = text_size + (padding * 2)
	$ColorRect2.scale.x = box_size.x / $ColorRect2.size.x
	$ColorRect.scale.x = $ColorRect2.scale.x
	
	# Optional: Center the RichTextLabel within the sprite
	$WrittenText.size = box_size
	$WrittenText.type_text(message)


func _on_written_text_finish_writting():
	$Timer.start(1)


func _on_timer_timeout():
	queue_free()
