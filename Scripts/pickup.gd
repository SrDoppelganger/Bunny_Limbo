extends Area2D

@onready var sprite2D = $AnimatedSprite2D


func _on_body_entered(body):
	print("collected :3")
	queue_free()
	%Game_Manager.add_score()
	

