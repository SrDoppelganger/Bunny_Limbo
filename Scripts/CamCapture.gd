extends StaticBody2D

@onready var camera_capture = $Area2D

signal capture
signal release 

func _ready():
	pass

func _on_area_2d_body_entered(body):
	emit_signal("capture", self)

func _on_area_2d_body_exited(body):
	emit_signal("release", self)
