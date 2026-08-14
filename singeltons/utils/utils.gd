extends Node

var rng = RandomNumberGenerator.new()

## English source string -> German translation
var _de_map: Dictionary = {}
var _locale_loaded := false


func _ready() -> void:
	randomize()
	_load_locale()


func _load_locale() -> void:
	_de_map.clear()
	var path := "res://data/locale/de.json"
	if not FileAccess.file_exists(path):
		_locale_loaded = true
		return
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		_locale_loaded = true
		return
	var raw := f.get_as_text()
	var json := JSON.new()
	var err := json.parse(raw)
	if err == OK and typeof(json.data) == TYPE_DICTIONARY:
		_de_map = json.data
	_locale_loaded = true


func reload_locale() -> void:
	_load_locale()


func requierments_met(actions : Array[Action]) -> bool:
	for action in actions:
		if not action.requirement_met():
			return false
	return true


func string_to_id(text: String) -> String:
	var id := text.to_lower().strip_edges()
	id = id.replace(" ", "_")
	var regex := RegEx.new()
	regex.compile("[^a-z0-9_]")
	id = regex.sub(id, "", true)
	return id


## Localize EN source -> DE if language is de, then substitute runtime tokens.
func translate(text : String) -> String:
	if text.is_empty():
		return text
	text = _localize(text)
	if GameData == null:
		return text
	if not GameData.attributes_manager:
		return text
	if not GameData.combat_manager:
		return text
	if not GameData.ponygirl_manager:
		return text

	var ponygirl : Ponygirl = PonygirlManager.focused_ponygirl
	var pony_name : String = ponygirl.name if ponygirl != null else ""
	var replacements := {
		"{TITLE}": AttributesManager.boss_title,
		"{NAME}": AttributesManager.boss_name,
		"{PONYNAME}": pony_name,
		"{ENEMY_NAME}": CombatManager.enemy_name,

		"{GOOD_WAGE}": GameData.COSTS.good_wage,
		"{MEDIUM_WAGE}": GameData.COSTS.medium_wage,
		"{BAD_WAGE}": GameData.COSTS.bad_wage,
		"{COST_REST}": GameData.COSTS.rest,
		"{COST_TRAVEL}": GameData.COSTS.travel,
		"{COST_CHEAP_PONYGIRL}": GameData.COSTS.ponygirl_cheap,
		"{COST_PONYGIRL}": GameData.COSTS.ponygirl_normal,
		"{COST_TRAINING}": GameData.COSTS.training,
		"{COST_TEASING}": GameData.COSTS.teasing,
		"{COST_CLIMAX}": GameData.COSTS.climax,
	}
	for key in replacements:
		text = text.replace(key, str(replacements[key]))
	return text


func _localize(text: String) -> String:
	if not _locale_loaded:
		_load_locale()
	if Settings == null or not Settings.is_german():
		return text
	if _de_map.has(text):
		return str(_de_map[text])
	var normalized := text.replace("\r\n", "\n")
	if _de_map.has(normalized):
		return str(_de_map[normalized])
	var stripped := normalized.strip_edges()
	if stripped != normalized and _de_map.has(stripped):
		return str(_de_map[stripped])
	if stripped.ends_with(" ") == false and _de_map.has(stripped + " "):
		return str(_de_map[stripped + " "])
	return text


## Walk a control tree and translate Label / LinkButton / LineEdit placeholders.
## DefaultBtn handles itself via language_changed; skip those.
func localize_tree(root: Node) -> void:
	if root == null:
		return
	_localize_node_recursive(root)


func _localize_node_recursive(node: Node) -> void:
	if node is DefaultBtn:
		pass
	elif node is Label:
		var label := node as Label
		if label.has_meta("locale_dynamic") and bool(label.get_meta("locale_dynamic")):
			pass
		else:
			if not label.has_meta("locale_src"):
				label.set_meta("locale_src", label.text)
			label.text = translate(str(label.get_meta("locale_src")))
	elif node is LinkButton:
		var link := node as LinkButton
		if not link.has_meta("locale_src"):
			link.set_meta("locale_src", link.text)
		link.text = translate(str(link.get_meta("locale_src")))
	elif node is LineEdit:
		var edit := node as LineEdit
		if not edit.placeholder_text.is_empty():
			if not edit.has_meta("locale_ph"):
				edit.set_meta("locale_ph", edit.placeholder_text)
			edit.placeholder_text = translate(str(edit.get_meta("locale_ph")))
	for child in node.get_children():
		_localize_node_recursive(child)


## Mark a Label as dynamic (code-driven). Optional: set English source and apply translation.
func set_dynamic_label(label: Label, english_source: String) -> void:
	if label == null:
		return
	label.set_meta("locale_dynamic", true)
	label.set_meta("locale_src", english_source)
	label.text = translate(english_source)


func roll_dice(max_number := 100):
	return rng.randi_range(1, max_number)
