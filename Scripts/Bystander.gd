extends RigidBody


signal on_bystander_about_to_dissapear
signal on_patrol_ended

const MINIMAL_DISTANCE_TO_TARGET = 0.125
const speed = 5

var target : Vector3


func hitted():
	$Timer.start()


func _on_Timer_timeout():
	emit_signal("on_bystander_about_to_dissapear")
	queue_free()


func patrol_to(point):
	target = point
	var dir = (target- translation).normalized()
	set_linear_velocity(dir * speed)


func _physics_process(_delta):
	if (target- translation).length() < MINIMAL_DISTANCE_TO_TARGET:
		set_linear_velocity(Vector3.ZERO)
		emit_signal("on_patrol_ended", self)

