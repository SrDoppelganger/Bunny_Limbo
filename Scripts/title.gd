extends Node2D

func _input(event):
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	elif event is InputEventKey and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/levels/level_0.tscn")
