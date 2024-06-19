extends CharacterBody2D

#basic movement
const SPEED = 200.0
const SLAM_VELOCITY = 450.0
const SLIDE_SPEED = 400.0
const ACC = 1.0

#jump variables
@onready var jump_script = $"Jump script"
@onready var jump_buffer_timer = $timers/buffer_timer
@onready var wall_collider = $wallCollider

var wall_jump = 4
var can_jump = false
var can_wall_jump = false

const WALL_JUMP_PUSHBACK = 250.0

#slide variables
var facing_direction = 1
var slamming = false

#dash variables
var dash_direction = Vector2(1,0)
var canDash = false
var isDashing = false

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
		velocity.x = velocity.x
		animation.play("airborne")
	else:
		animation.play("idle")
	
	# Get the input direction and handle the movement/deceleration.
	# Var direction stores a value between -1,0 and 1
	var direction = Input.get_axis("move_left", "move_right")
	if direction and !Input.is_action_pressed("slide") and !isDashing:
		velocity.x = move_toward(velocity.x, direction * SPEED, 64.0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#declare was_on_floor for coyote time
	var was_on_floor = is_on_floor()
		
	#Handle jump buffering for normal jumping and wall jumping
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()
	if is_on_floor() and !jump_buffer_timer.is_stopped():
		can_jump = true
	if !is_on_floor() and wall_collider.is_colliding() and !jump_buffer_timer.is_stopped():
		can_wall_jump = true
	else:
		can_wall_jump = false
	
	# Handle Jump
	if can_jump or (Input.is_action_just_pressed("jump") and !coyote_timer.is_stopped()):
		animation.play("jump_Start")
		velocity.y = jump_script.jump_velocity
		can_jump = false
		
	#handle wall slide
	wall_collider.scale.x = facing_direction
	if direction != 0 and wall_collider.is_colliding() and !is_on_floor():
		velocity.y = 40
		animation.play("wall_slide")
		
	#handle wall jump 
	if Input.is_action_just_pressed("jump") and (can_wall_jump and wall_jump > 0):
		velocity.y = jump_script.jump_velocity
		velocity.x = WALL_JUMP_PUSHBACK * (facing_direction * -1)
		animation.flip_h
		wall_jump -= 1
	
	# handle slam
	if Input.is_action_just_pressed("slam") and not is_on_floor():
		slamming = true
		animation.play("airborne")
		velocity.y = SLAM_VELOCITY
		
	# handle slide
	if Input.is_action_pressed("slide") and !slamming:
		animation.play("slide")
		velocity.x = lerp(SLIDE_SPEED * facing_direction, 0.0,0.2)
		
	#handle dash:
	#gets the facing direction to assign a direction to the dash
	dash_direction = Vector2(facing_direction,0)
	
	if Input.is_action_just_pressed("dash") and canDash:
		velocity = dash_direction.normalized() * 1600.0
		canDash = false
		isDashing = true
		
		#sets dash time
		await(get_tree().create_timer(0.2).timeout) 
		isDashing = false
	if isDashing:
		set_collision_layer_value(2, false)
	else:
		set_collision_layer_value(2,true)
		
	#handle animations and facing direction
	if Input.is_action_just_pressed("move_right"):
		animation.flip_h = false
		facing_direction = 1
	elif Input.is_action_just_pressed("move_left"):
		animation.flip_h = true
		facing_direction = -1
	
	#reset values when player touches the floor
	if is_on_floor():
		wall_jump = 3
		jump_buffer_timer.stop()
		slamming = false
		canDash = true
		
		
	move_and_slide()
	
	#coyote timer
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
