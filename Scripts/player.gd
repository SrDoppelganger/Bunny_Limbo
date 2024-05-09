extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -350.0

@onready var animation = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		animation.play("airborne")
	else:
		animation.play("idle")
		
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animation.play("jump_Start")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# Var direction stores a value between -1,0 and 1
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#handle animations
	if Input.is_action_just_pressed("move_right"):
		animation.flip_h = false
	elif Input.is_action_just_pressed("move_left"):
		animation.flip_h = true

	move_and_slide()
