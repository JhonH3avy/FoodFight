extends KinematicBody

const PROYECTILE_SPEED = 50
const PROYECTILE_MODELS_FOLDER_PATH = "res://Scenes/Ammo/AmmoScenes/"

var ammo_types = {}

var can_fire : bool


func _enter_tree():
	ammo_types = FileWrapper.get_files(PROYECTILE_MODELS_FOLDER_PATH)
	randomize()
	can_fire = true
	


func fire():
	var random_bullet = ammo_types[randi() % ammo_types.size()]
	var bullet = load(random_bullet).instance()
	add_child(bullet)
	bullet.set_as_toplevel(true)
	bullet.global_transform = $Forward.global_transform
	var character_forward = get_global_transform().basis.z.normalized()
	bullet.shoot_at(character_forward, PROYECTILE_SPEED)
	bullet.add_collision_exception_with(self)


func _on_CanFire_timeout():
	can_fire = true
