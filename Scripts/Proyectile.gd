extends RigidBody


export var bullet_lifetime : int = 3


func shoot_at(dir, speed):
	$LifeTime.wait_time = bullet_lifetime
	$LifeTime.start()
	set_linear_velocity(dir * speed)

func _on_LifeTime_timeout():
	queue_free()
