extends Control

@onready var name_line: LineEdit = %NameLine
@onready var warband_line: LineEdit = %WarbandLine

var boss_names = [
	"Snikk",
	"Grub",
	"Razzit",
	"Boglug",
	"Krikk",
	"Zugga",
	"Mog",
	"Nibbit",
	"Skazz",
	"Vrik",
	"Gritch",
	"Drub",
	"Snotz",
	"Kragga",
	"Zibble",
	"Grott",
	"Bazzik",
	"Uggs"
]
var boss_titles = [
	"Boss",
	"Big Boss",
	"Chief",
	"Warboss",
	"Warlord",
	"Overboss",
	"Captain",
	"Master",
	"Chief",
	"Mud King",
	"Bone Lord",
	"Lord",
	"Pit Master"
]
var last_names: Array[String] = []
var last_titles: Array[String] = []

func _ready() -> void:
	if Utils:
		Utils.localize_tree(self)
	if GlobalSignals and not GlobalSignals.language_changed.is_connected(_on_language_changed):
		GlobalSignals.language_changed.connect(_on_language_changed)
	_roll_name()
	_roll_title()


func _on_language_changed() -> void:
	if Utils:
		Utils.localize_tree(self)

func _on_start_game_btn_pressed() -> void:
	SaveGame.new_game(name_line.text, warband_line.text)
	await get_tree().create_timer(0.1).timeout
	SceneManager.change_scene(SceneManager.MAIN_WINDOW)

func _on_rng_name_btn_pressed() -> void:
	_roll_name()

func _on_rng_titel_btn_pressed() -> void:
	_roll_title()

func _roll_name() -> void:
	var available_names := boss_names.filter(
		func(name: String) -> bool:
			return name not in last_names
	)
	var new_name: String = available_names.pick_random()
	name_line.text = new_name
	last_names.push_back(new_name)
	if last_names.size() > 2:
		last_names.pop_front()

func _roll_title() -> void:
	var available_titles := boss_titles.filter(
		func(title: String) -> bool:
			return title not in last_titles
	)
	var new_title: String = available_titles.pick_random()
	warband_line.text = new_title
	last_titles.push_back(new_title)
	if last_titles.size() > 2:
		last_titles.pop_front()
