extends StoryPage

@onready var location_label: Label = %LocationLabel
@onready var mouse_area: Area2D = %MouseArea

var dict_of_markers: Dictionary = {}

func _ready() -> void:
	super()
	GlobalSignals.update_location.connect(_on_update_location)
	if GlobalSignals and not GlobalSignals.language_changed.is_connected(_on_update_location):
		GlobalSignals.language_changed.connect(_on_update_location)
	_on_update_location()
	mouse_area.visible = true

func _on_update_location() -> void:
	var loc_title: String = Utils.translate(LocationManager.current_location.title)
	location_label.text = Utils.translate("Current Location: %s") % loc_title

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		GlobalSignals.travel_suggestion.emit(get_global_mouse_position())
