extends Control



func _on_play_pressed():
	get_tree().change_scene_to_file("res://world/world.tscn")


func _on_pressed():
	get_tree().quit()


func _on_note_pressed():
	Global.music_control = !Global.music_control
	var audio = get_parent().get_parent().get_parent().get_node("AudioStreamPlayer")
	var note = get_parent().get_parent().get_parent().get_node("Note")
	
	if audio != null:
		if Global.music_control:
			audio.stop()
			note.icon = load("res://assets/note_off.png")
		else: 
			audio.play()
			note.icon = load("res://assets/note_on.png")
