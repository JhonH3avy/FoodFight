extends Camera

export var mouse_sensitivity = 1200

export(NodePath) var PlayerPath

var Player : KinematicBody

func _ready():
	Player = get_node(PlayerPath)

func _enter_tree():
	lock_mouse()


func _exit_tree():
	release_mouse()


func lock_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _input(event):
	if event is InputEventMouseMotion:
		return mouse(event)


func mouse(event):
	Player.set_rotation(look_left_right(-event.relative.x / mouse_sensitivity))
	set_rotation(look_up_down(-event.relative.y / mouse_sensitivity))


func look_left_right(rot):
	return Player.get_rotation() + Vector3(0, rot, 0)


func look_up_down(rot):
	var new_rotation = get_rotation() + Vector3(rot, 0, 0)
	new_rotation.x = clamp(new_rotation.x, PI / -4, PI / 8)
	return new_rotation
