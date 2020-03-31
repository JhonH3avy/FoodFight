extends RigidBody


signal on_bystander_about_to_dissapear
signal on_patrol_ended

export var patrol_duration = 2.5


func hitted():
	$Timer.start()


func _on_Timer_timeout():
	emit_signal("on_bystander_about_to_dissapear")
	queue_free()


func patrol_to(point):
	$Tween.interpolate_property(self, "position", translation, point, patrol_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)


func _on_Tween_tween_completed(_object, _key):
	emit_signal("on_patrol_ended", self)
