extends OptionButton

# Array of font resources to display in the dropdown
var fonts = [
	preload("res://Fonts/FFSpokenTrial-Regular.ttf"),
	preload("res://Fonts/HappyDay-Regular.ttf"),
	preload("res://Fonts/Pencilant Script.ttf")
]

# Array of font names for display
var font_names = [
	"FF Spoken Trial",
	"Happy Day",
	"Pencilant Script"
]

func _ready():
	# Populate the OptionsButton with font names
	for i in range(fonts.size()):
		add_item(font_names[i], i)
	
	# Connect the item_selected signal to handle selection
	item_selected.connect(_on_item_selected)

func _on_item_selected(index: int):
	# Emit the selected font (or handle as needed)
	print("Selected font: ", font_names[index])
	# You can emit a signal here if needed, e.g., signal font_changed(fonts[index])
	var theme = load("res://Style.theme")
	theme.set_default_font(fonts[index])
	

# Optional: Signal to notify when a font is selected
signal font_changed(font)
