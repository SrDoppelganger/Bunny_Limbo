extends Node2D

@onready var camera = $"../Camera2D"
@onready var player = $"../Player"


var target = null


func _ready():
	
	target = player
	
	for i in get_tree().get_nodes_in_group("rooms"):
		i.capture.connect(self.set_camera)
		i.release.connect(self.release_camera)
	

func _process(delta):
	camera.set_position(target.get_position())

func set_camera(room):
	target = room
	
func release_camera():
	target = player
