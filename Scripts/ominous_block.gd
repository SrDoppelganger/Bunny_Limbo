extends Node2D

const SPEED = 250.0

var direction = 1

@onready var lower_ray_cast_2d = $LowerRayCast2D
@onready var upper_ray_cast_2d = $UpperRayCast2D

func _process(delta):
	
	position.y += direction * SPEED * delta
	
	if lower_ray_cast_2d.is_colliding():
		direction = -1
	if upper_ray_cast_2d.is_colliding():
		direction = 1
