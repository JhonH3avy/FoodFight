extends "res://Scripts/Character.gd"


# movement variables
var vel = Vector3()
var dir = Vector3()
var facing_direction = 0

# movement constants
const GRAVITY = -45
const MAX_SPEED = 20
const ACCEL = 5
const DECCEL = 10
const JUMP_SPEED = 15

# animation constants
const BLEND_MINIMUM = 0.125
const RUN_BLEND_AMOUNT = 0.1
const IDLE_BLEND_AMOUNT = 0.025

# animation variables
var move_state = 0

func _process(delta):
	move(delta)
	face_forward()
	animate()


func move(delta):
	var movement_dir = get_2d_movement()
	var camera_xfor = $Camera.get_global_transform()
	
	dir = Vector3(0,0,0)
	dir -= camera_xfor.basis.z.normalized() * movement_dir.y
	dir -= camera_xfor.basis.x.normalized() * movement_dir.x
	
	dir = move_vertically(dir, delta)
	vel = h_accel(dir, delta)
	
	vel = move_and_slide(vel, Vector3.UP)


func get_2d_movement():
	var movement_vector = Vector2()
	if Input.is_action_pressed("forward") and not Input.is_action_pressed("backward"):
		movement_vector.y = 1
		facing_direction = 0
	elif Input.is_action_pressed("backward") and not Input.is_action_pressed("forward"):
		movement_vector.y = -1
		facing_direction = PI
	else:
		movement_vector.y = 0
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		movement_vector.x = 1
		facing_direction = PI * 0.5
	elif Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		movement_vector.x = -1
		facing_direction = PI * 1.5
	else:
		movement_vector.x = 0
	return movement_vector.normalized()


func move_vertically(direction, delta):
	vel.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y = JUMP_SPEED
	elif is_on_floor():
		vel.y = 0
	
	direction.y = 0
	direction.normalized()
	return direction


func h_accel(direction, delta):
	var vel_2d = vel
	vel_2d.y = 0
	
	var target = direction
	target *= MAX_SPEED
	
	var accel
	if direction.dot(vel_2d) > 0:
		accel = ACCEL
	else:
		accel = DECCEL
	
	vel_2d = vel_2d.linear_interpolate(target, accel * delta)
	
	vel.x = vel_2d.x
	vel.z = vel_2d.z
	
	return vel


func face_forward():
	$Armature.rotation.y = facing_direction


func animate():
	var animationTree = $Armature/AnimationTree
	if vel.length() > BLEND_MINIMUM:
		move_state += RUN_BLEND_AMOUNT
	else:
		move_state -= IDLE_BLEND_AMOUNT
	move_state = clamp(move_state, 0, 1)
	animationTree["parameters/Motion/blend_amount"] = move_state


func _input(_event):
	if Input.is_action_just_pressed("fire"):
		try_to_fire()


func try_to_fire():	
	if can_fire:
		fire()
		can_fire = false
		$CanFire.start()

