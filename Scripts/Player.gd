extends KinematicBody

export var SPEED = 2.5

const GRAVITY = -1

# movement variables
var motion = Vector3()
var facing_direction = 0

# animation constants
const BLEND_MINIMUM = 0.125
const RUN_BLEND_AMOUNT = 0.1
const IDLE_BLEND_AMOUNT = 0.075

# animation variables
var move_state = 0

func _process(delta):
	move()
	#apply_gravity()
	face_forward()
	animate()


func apply_gravity():
	if not is_on_floor():
		motion.y = GRAVITY
	else:
		motion.y = 0

func move():
	if Input.is_action_pressed("forward") and not Input.is_action_pressed("backward"):
		motion.z = 1
		facing_direction = 0
	elif Input.is_action_pressed("backward") and not Input.is_action_pressed("forward"):
		motion.z = -1
		facing_direction = PI
	else:
		motion.z = 0
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		motion.x = 1
		facing_direction = PI * 0.5
	elif Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		motion.x = -1
		facing_direction = PI * 1.5
	else:
		motion.x = 0
	move_and_slide(motion * SPEED, Vector3.UP)


func face_forward():
	$Armature.rotation.y = facing_direction


func animate():
	var animationTree = $Armature/AnimationTree
	if motion.length() > BLEND_MINIMUM:
		move_state += RUN_BLEND_AMOUNT
	else:
		move_state -= IDLE_BLEND_AMOUNT
	move_state = clamp(move_state, 0, 1)
	animationTree["parameters/Motion/blend_amount"] = move_state

