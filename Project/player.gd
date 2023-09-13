extends CharacterBody2D

signal groundedUpdated(isGrounded) 

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DOUBLE_JUMP_VELOCITY = -600.0

@export var jump_buffer_time : float = 0.1
@export var double_jump_time : float = 0.1
@export var coyote_time : float = 0.15
@export var fall_multiplier : float = 2.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var canDoubleJump = false
var jumping = false
var doubleJumping = false
var jumpBufferTimer: float = 0.0
var coyoteTimer: float = 0.0
var isGrounded = false

@onready var sprite = $Sprite
@onready var jump_timer = $JumpTimer

func _input(event):
	if Input.is_action_just_pressed("jump"):
		if coyoteTimer > 0:
			jumpBufferTimer = jump_buffer_time

func _ready():
	jump_timer.wait_time = double_jump_time

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += gravity  * delta
		else:
			velocity.y += gravity * fall_multiplier * delta
		
	handle_jump(delta)
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	var wasGrounded = isGrounded
	isGrounded = is_on_floor()
	if isGrounded != wasGrounded:
		emit_signal("groundedUpdated", isGrounded)

func handle_jump(delta):
	if is_on_floor():	
		coyoteTimer = coyote_time
	
	jumpBufferTimer -= delta
	coyoteTimer -= delta
	
	if jumping and is_on_floor():
		jumping = false
		doubleJumping = false
		if not canDoubleJump:
			canDoubleJump = true
			jump_timer.start()
	
	if jumpBufferTimer > 0 and (is_on_floor() or (coyoteTimer > 0 and not jumping)) :
		jumping = true
		if not canDoubleJump:			
			velocity.y = JUMP_VELOCITY			
		else:
			velocity.y = DOUBLE_JUMP_VELOCITY
			doubleJumping = true
			
func _on_jump_timer_timeout():
	canDoubleJump = false
	
func Destruct():
	get_tree().quit()
