extends Resource
class_name Combat

@export var title := ""
@export var difficulty_penalty := 0
@export var scenes : Array[CombatScene]

@export_group("Enemies")
@export var enemy_descriptors : Array[String] = ["Wild"]
@export var enemy_names : Array[String] = ["Orks"]

@export_group("Combat Result")
@export var victory_actions : Array[Action] = []
@export var defeat_actions : Array[Action] = []

@export var victory_img : Texture2D
@export var defeat_img : Texture2D
@export_multiline var victory_txt := ""
@export_multiline var defeat_txt := ""

func get_enemy_name() -> String:
	if enemy_descriptors.is_empty() and enemy_names.is_empty():
		return ""
	if enemy_descriptors.is_empty():
		return enemy_names.pick_random()
	if enemy_names.is_empty():
		return enemy_descriptors.pick_random()
	return "%s %s" % [
		enemy_descriptors.pick_random(),
		enemy_names.pick_random()
	]

func get_next_scene(last_scene : CombatScene) -> CombatScene:
	if scenes.is_empty(): return null
	scenes.shuffle()
	var selected_scene := scenes[0]
	if selected_scene == last_scene and scenes.size() > 1:
		selected_scene = scenes[1]
	return selected_scene
