extends CharacterBody2D

#basic movement
const SPEED = 150.0
const SLAM_VELOCITY = 450.0
const SLIDE_SPEED = 400.0
var jump_buffer = 0.0

@onready var jump_script = $"Jump script"


#slide variables
var facing_direction = 1

#coyote time variables
@onready var coyote_timer = $timers/Coyote_timer

#animation variables
@onready var animation = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += jump_script.get_gravity(velocity) * delta
		animation.play("airborne")
	else:
		animation.play("idle")
	
	# Get the input direction and handle the movement/deceleration.
	# Var direction stores a value between -1,0 and 1
	var direction = Input.get_axis("move_left", "move_right")
	if direction and not Input.is_action_pressed("slide"):
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#declare was_on_floor for coyote time
	var was_on_floor = is_on_floor()
		
	# Handle Jump
	
	#jump buffer allows for a little delay in the jumping input
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_buffer = 0.1
	jump_buffer -= delta
	
	if Input.is_action_just_pressed("jump") and (jump_buffer > 0 or !coyote_timer.is_stopped()):
		animation.play("jump_Start")
		velocity.y = jump_script.jump_velocity
		jump_buffer = 0.0
	
	# handle slam
	if Input.is_action_just_pressed("slam") and not is_on_floor():
		animation.play("airborne")
		velocity.y = SLAM_VELOCITY
		
	# handle slide
	if Input.is_action_pressed("slide") and is_on_floor():
		animation.play("slide")
		velocity.x = SLIDE_SPEED * facing_direction

	
	#handle animations and facing direction
	if Input.is_action_just_pressed("move_right"):
		animation.flip_h = false
		facing_direction = 1
	elif Input.is_action_just_pressed("move_left"):
		animation.flip_h = true
		facing_direction = -1
		
	move_and_slide()
	
	#coyote timer
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
