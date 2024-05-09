extends Node

var score = 0
@onready var hud = $"../HUD"

#counts carrots collected
func add_score():
	score += 1
	hud.get_node("GUI/score_label").text = "score:" + str(score)
	
