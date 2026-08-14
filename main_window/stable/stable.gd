extends StoryPage

const PONY_BTN = preload("uid://ck8d7c8olwxhh")
const QUEST_ICON = preload("uid://c3jxucw5l3to6")

@onready var titel_label: Label = %TitelLabel
@onready var active_list: GridContainer = %ActiveList
@onready var resting_list: GridContainer = %RestingList
@onready var quest_icons: GridContainer = %QuestIcons

func _ready() -> void:
	super()
	titel_label.text = "%s %s" % [AttributesManager.boss_title, AttributesManager.boss_name]
	GlobalSignals.update_ponygirls.connect(_update_ponygirls)

func _on():
	super()
	_update_ponygirls()

func _update_ponygirls() -> void:
	Utils.clear_container(active_list)
	Utils.clear_container(resting_list)
	Utils.clear_container(quest_icons)
	_add_ponygirls()
	_add_quest_icons()

func _add_quest_icons() -> void:
	for flag: Flag in FlagsManager.flags.values():
		if not flag.add_quest_icon():
			continue
		var icon = QUEST_ICON.instantiate()
		icon.flag = flag
		quest_icons.add_child(icon)

func _add_ponygirls() -> void:
	for pony in PonygirlManager.ponygirls:
		var btn := PONY_BTN.instantiate()
		btn.ponygirl = pony
		if pony.active:
			btn.active_btn = true
			active_list.add_child(btn)
		else:
			btn.active_btn = false
			resting_list.add_child(btn)
	while active_list.get_child_count() < PonygirlManager.MAX_ACTIVE:
		var btn := PONY_BTN.instantiate()
		btn.active_btn = true
		active_list.add_child(btn)
	while resting_list.get_child_count() < PonygirlManager.MAX_RESTING:
		var btn := PONY_BTN.instantiate()
		btn.active_btn = false
		resting_list.add_child(btn)
