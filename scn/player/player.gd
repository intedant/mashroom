extends CharacterBody2D

enum {
	IDLE,
	MOVE,
	ATTACK,
	ATTACK2,
	ATTACK3,
	BLOCK,
	SLIDE
}

const SPEED = 150.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer

var health = 100
var gold = 0
var state = MOVE
var runSpeed = 1
var combo = false
var attackColdown = false
var player_pos

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if velocity.y > 0:
		animPlayer.play("fall")
		
	if health <= 0:
		health = 0	
		animPlayer.play("death")
		await animPlayer.animation_finished
		queue_free()
		get_tree().change_scene_to_file("res://scn/scens/menu/menu.tscn")
		
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()	
		ATTACK2:
			attack2_state()
		ATTACK3:
			attack3_state()
		BLOCK:
			block_state()
		SLIDE:
			slide_state()
			
	move_and_slide()
	
	player_pos = self.position
	Signals.emit_signal("player_position_update", player_pos)
	
	
func move_state():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * runSpeed
		if velocity.y == 0:	
			if runSpeed == 1:
				animPlayer.play("wallk")
			else:
				animPlayer.play("run")	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:	
			animPlayer.play("idle")
			
			
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("run"):
		runSpeed = 2
	else:
		runSpeed = 1	
		
	if Input.is_action_pressed("block"):
			state = BLOCK
	
				
	if Input.is_action_pressed("slide"):
		if velocity.x == 0:
			state = MOVE
		else:
			state = SLIDE	
	
	if Input.is_action_just_pressed("attack") and attackColdown == false:
		state = ATTACK
					
func block_state():
	velocity.x = 0
	animPlayer.play("block")
	if Input.is_action_just_released("block"):
		state = MOVE
		
func  slide_state():
	animPlayer.play("slide")
	await animPlayer.animation_finished
	state = MOVE	
		
func attack_state():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK2
	velocity.x = 0
	animPlayer.play("attack")
	await animPlayer.animation_finished
	attak_freeze()
	state = MOVE
	
func attack2_state():
	if Input.is_action_just_pressed("attack") and combo == true:
		state= ATTACK3
	animPlayer.play("attack2")
	await animPlayer.animation_finished
	state = MOVE	
	
func attack3_state():
	animPlayer.play("attack3")
	await animPlayer.animation_finished
	state = MOVE	
		
func combo_1():
	combo = true
	await animPlayer.animation_finished
	combo = false
	
func attak_freeze():
	attackColdown = true
	await get_tree().create_timer(0.5).timeout
	attackColdown = false
