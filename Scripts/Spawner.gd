tool
extends Spatial


const BYSTANDERS_VARIATIONS_FOLDER_PATH = "res://Scenes/Characters/Bystanders/Variations/"
export var BYSTANDERS_MAX_COUNT = 5

export(NodePath) var initial_patrol_position_nodepath
var initial_patrol_position

export(Array, NodePath) var patrol_points_nodepath
var patrol_points = []

var bystanders_count = 0


func _enter_tree():
	randomize()


func _ready():
	initial_patrol_position = get_node(initial_patrol_position_nodepath)
	for nodepath in patrol_points_nodepath:
		patrol_points.append(get_tree().get_root().get_node(nodepath))
	if Engine.editor_hint:
		$MeshInstance.visible = true
	else:
		$MeshInstance.visible = false


func _on_Timer_timeout():
	create_bystander()


func create_bystander():
	if bystanders_count <= BYSTANDERS_MAX_COUNT:
		var bystanders_variations = FileWrapper.get_files(BYSTANDERS_VARIATIONS_FOLDER_PATH)
		var bystander_model = bystanders_variations[randi() % bystanders_variations.size()]
		var bystander_node = load(bystander_model).instance()
		bystander_node.connect("on_bystander_about_to_dissapear", self, "bystander_disspeared")
		bystander_node.connect("on_patrol_ended", self, "reassgin_patrol_point_to_bystander")
		bystanders_count += 1
		bystander_node.patrol_to(initial_patrol_position.translation)


func reassgin_patrol_point_to_bystander(bystander):
	var patrol_point = get_next_patrol_point()
	bystander.patrol_to(patrol_point)


func get_next_patrol_point():
	return patrol_points[randi() % patrol_points.size()]


func bystander_disspeared():
	bystanders_count -= 1
