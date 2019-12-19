extends KinematicBody

const SPEED = 0.5

var motion = Vector3()

func _process(delta):
	move()


func move():
	if Input.is_action_pressed("forward") and not Input.is_action_pressed("backward"):
		motion.z = 1
	elif Input.is_action_pressed("backward") and not Input.is_action_pressed("forward"):
		motion.z = -1
	else:
		motion.z = 0
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		motion.x = -1
	elif Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		motion.x = 1
	else:
		motion.x = 0
	move_and_slide(motion, Vector3.UP)

