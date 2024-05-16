extends Node

#made a separate script for jump for cleaner code

@export var jump_h:float
@export var jump_peak:float
@export var jump_d:float

@onready var jump_velocity:float = ((2.0 * jump_h) / jump_peak) * -1
@onready var jump_gravity:float = ((-2.0 * jump_h) / (jump_peak ** 2)) * -1
@onready var fall_gravity:float = ((-2.0 * jump_h) / (jump_d ** 2)) * -1

func get_gravity(vector2):
		return jump_gravity if vector2.y < 0.0 else fall_gravity
