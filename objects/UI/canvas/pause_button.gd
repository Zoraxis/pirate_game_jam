extends Button
#
#func _input(event):
	#if event.is_action_pressed("action_shoot"):
		

func menu():
	Global.togglePause()
	var pauseMenu = get_parent().get_node("PauseMenu")
	if pauseMenu != null:
		pauseMenu.visible = Global.opened

func _on_pressed():
	menu()
