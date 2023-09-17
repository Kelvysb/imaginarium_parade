extends CharacterBody2D
class_name  Player

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const DOUBLE_JUMP_VELOCITY = -700.0
const DASH_SPEED = 1000

@export var hud : HUD
@export var jump_buffer_time : float = 0.1
@export var double_jump_time : float = 0.1
@export var atack_time : float = 0.2
@export var special_charge_time : float = 10
@export var spin_atack_time : float = 0.2
@export var coyote_time : float = 0.15
@export var dash_time : float = 0.3
@export var recover_time : float = 3
@export var fall_multiplier : float = 2.0
@export var maxLifes : int = 3

var jumpBufferTimer: float = 0.0
var coyoteTimer: float = 0.0
var dashTimer: float = 0.0
var atackTimer : float = 0.0
var specialTimer : float = 0.0
var recoverTimer : float = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var canDoubleJump = false
var canDashJump = true
var canSpecial = true
var jumping = false
var doubleJumping = false
var dashing = false
var isGrounded = false
var atacking = false
var recovering = false
var facing = 1

var life : int = 0
var score : int = 0

@onready var jump_timer = $JumpTimer
@onready var dash_particle = $Sprites/SpriteGroup/DashParticle
@onready var run_particle = $RunParticle
@onready var jump_particle = $JumpParticle
@onready var atack = $Atack
@onready var spin_atack = $SpinAtack
@onready var atack_area1 = $SpinAtack/AtackArea
@onready var atack_area2 = $Atack/AtackArea
@onready var recover_animation = $RecoverAnimation
@onready var animation_tree = $AnimationTree
@onready var sprite_group = $Sprites/SpriteGroup
@onready var animation_tree_atack = $AnimationTreeAtack
@onready var spin_atack_trail = $SpinAtackTrail
@onready var atacktrail = $Atacktrail
@onready var global = get_node("/root/GlobalGameData") as GameData

func _input(event):
	if Input.is_action_just_pressed("jump"):
		jumpBufferTimer = jump_buffer_time	

func _ready():
	life = maxLifes
	jump_timer.wait_time = double_jump_time
	
func _physics_process(delta):
	handle_grounded()
	handleHUD()	
	handleRecovering(delta)
	handleSpecialCharge(delta)
	if not dashing:			
		handle_gravity(delta)
		handle_jump(delta)
		handle_direction(delta)
	handle_atack(delta)
	handle_dash(delta)
	handle_run_particles()
	move_and_slide()		


func handleHUD():
	hud.SetLifes(life)

func handleRecovering(delta):
	if recovering:
		recoverTimer -= delta
		if recoverTimer <= 0:
			recover_animation.stop()
			recovering = false	

func handleSpecialCharge(delta):
	if specialTimer > 0:
		specialTimer -= delta
		var value = remap(specialTimer, special_charge_time, 0, 0, 100)
		hud.SetSpecial(value)
	if specialTimer <= 0:
		canSpecial = true
		hud.SetSpecial(100)

func handle_gravity(delta):
	if not is_on_floor():
			if velocity.y < 0:
				velocity.y += gravity  * delta
			else:
				velocity.y += gravity * fall_multiplier * delta	

func handle_direction(delta):
	var direction = Input.get_axis("left", "right")
	if direction :
		velocity.x = direction * SPEED
		if direction > 0:
			atack.scale.x = 1
			sprite_group.scale.x = 1
			atacktrail.flip_h = false
			facing = 1
		else:
			atack.scale.x = -1
			atacktrail.flip_h = true
			sprite_group.scale.x = -1
			facing = -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	animation_tree.set("parameters/BlendSpace1D/blend_position", absf(velocity.x))

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
			animation_tree.set("parameters/spin/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
			velocity.y = DOUBLE_JUMP_VELOCITY
			doubleJumping = true
		jump_particle.emitting = true

func handle_dash(delta):
	if not is_on_floor() and canDashJump and (Input.is_action_pressed("dash") or (Input.is_action_pressed("special") and canSpecial)):	
		canDashJump = false
		velocity.y = 0
		velocity.x = facing * DASH_SPEED
		dashing = true
		dashTimer = dash_time
		dash_particle.emitting = true
		if Input.is_action_pressed("special"):
			specialTimer = special_charge_time
			canSpecial = false
	elif (Input.is_action_pressed("dash") or Input.is_action_pressed("special")) and dashing:
		dashTimer -= delta
		if dashTimer <= 0:
			dashing = false
			dash_particle.emitting = false
		else:
			velocity.x = move_toward(velocity.x, 0, 0.1)
	else:
		dashing = false
		dash_particle.emitting = false
		dashTimer = 0
		velocity.x = move_toward(velocity.x, 0, 0.1)

func handle_run_particles():
	if is_on_floor() and velocity.length() > 0:
		run_particle.emitting = true
	else:
		run_particle.emitting = false
	
func handle_grounded():
	var wasGrounded = isGrounded
	isGrounded = is_on_floor()
	if isGrounded:
		animation_tree.set("parameters/spin/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT);
	if isGrounded != wasGrounded:
		canDashJump = true

func handle_atack(delta):
	if atackTimer > 0:
		atackTimer -= delta
		CheckObstacles()
	else:	
		if Input.is_action_just_pressed("atack") or (Input.is_action_just_pressed("special") and canDashJump and canSpecial and jumping):
			if not doubleJumping:
				atackTimer = atack_time				
				animation_tree_atack.set("parameters/Spin/blend_amount", 0)
			else:					
				atackTimer = spin_atack_time	
				spin_atack_trail.visible = true
				animation_tree_atack.set("parameters/Spin/blend_amount", 1)
			atacking = true
			animation_tree_atack.set("parameters/Atack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			CheckObstacles()
	
	if atackTimer <= 0:
		spin_atack_trail.visible = false
		atacking = false
		animation_tree_atack.set("parameters/Atack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		
func _on_jump_timer_timeout():
	canDoubleJump = false
	
	
func WinScore(value : int):
	score += value
	score += (life * 50)
	global.TotalScore = score
	
func Damage():
	if not recovering:
		life -= 1
		hud.SetLifes(life)
		if life <= 0:
			get_tree().change_scene_to_file("res://Interfaces/GameOver.tscn")
		else:
			recovering = true
			recoverTimer = recover_time
			recover_animation.play("Recover")

func CheckObstacles():
	if atacking:
		var obstacles = atack_area1.get_overlapping_bodies() as Array[Node2D]
		obstacles.append_array(atack_area2.get_overlapping_bodies())
		for obstacle in obstacles:
			if obstacle.is_in_group("obstacle"):
				score += obstacle.Points
				global.TotalScore = score
				hud.SetScore(score)
				obstacle.Kill()

func _on_hit_box_body_entered(body):
	if (body as Node2D).is_in_group("obstacle") and not recovering:
		Damage();
		(body as Obstacle).Destruct()
	if (body as Node2D).is_in_group("lifeup"):
		if life < maxLifes:
			life+=1
		body.Destruct()
