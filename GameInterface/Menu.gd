extends Node2D

func _on_area_2d_mouse_entered():
	$Closed/FtMenuPeice.modulate = Color.AQUA


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		$Closed.visible = false
		$Open.visible = true


func _on_area_2d_mouse_exited():
	$Closed/FtMenuPeice.modulate = Color(1.0, 1.0, 1.0)


func _on_tab_container_tab_clicked(tab : int):
	if(tab == 3) : 
		self.visible =false
		$TabContainer.current_tab = 0


func _on_report_bug_pressed():
	$BugReport.visible = true


func _on_bug_report_cancel_pressed():
	$BugReport.visible = false
func _on_confirm_bug_report_pressed():
	$BugReport.visible = false


func _on_check_box_toggled(button_pressed):
	if button_pressed:
		get_window().mode = Window.MODE_FULLSCREEN
	else :
		get_window().mode = Window.MODE_WINDOWED


func _on_exit_game_pressed():
	get_tree().quit()

func _unhandled_key_input(event):
	if event.is_action("MainMenu"):
		self.visible = true
