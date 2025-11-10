extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Cover.visible = true
	$Open.visible = false

func _on_tab_bar_tab_selected(tab: int):
	if tab == 0 :
		$Cover.visible = true
		$Open.visible = false
	else :
		$Cover.visible = false
		$Open.visible = true
		#Tabs
		$Open/Genre.visible = (tab == 1)
		$Open/Stories.visible = (tab == 2)
		$Open/Adventure.visible = (tab == 3)
		$Open/Event.visible = (tab == 4)

