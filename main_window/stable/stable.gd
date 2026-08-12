extends StoryPage

var pony_btn = preload("res://main_window/stable/pony_btn.tscn")
@onready var titel_label: Label = %TitelLabel
@onready var active_list: GridContainer = %ActiveList
@onready var resting_list: GridContainer = %RestingList

func _ready() -> void:
	super()
	titel_label.text = "%s %s" % [AttributesManager.boss_title, AttributesManager.boss_name]
	GlobalSignals.update_ponygirls.connect(_update_ponygirls)

func _on():
	super()
	_update_ponygirls()

func _update_ponygirls() -> void:
	_clear_container(active_list)
	_clear_container(resting_list)
	for pony in PonygirlManager.ponygirls:
		var btn := pony_btn.instantiate()
		btn.ponygirl = pony
		if pony.active:
			btn.active_btn = true
			active_list.add_child(btn)
		else:
			btn.active_btn = false
			resting_list.add_child(btn)
	while active_list.get_child_count() < PonygirlManager.MAX_ACTIVE:
		var btn := pony_btn.instantiate()
		btn.active_btn = true
		active_list.add_child(btn)
	while resting_list.get_child_count() < PonygirlManager.MAX_RESTING:
		var btn := pony_btn.instantiate()
		btn.active_btn = false
		resting_list.add_child(btn)

func _clear_container(container: Container) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
