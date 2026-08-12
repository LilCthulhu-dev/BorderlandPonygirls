extends Node2D

@onready var path_line: Line2D = %PathLine
@onready var target: Node2D = %Target
@onready var player: Node2D = %Player
@onready var travel_btn: Button = %TravelBtn
@onready var player_area: Area2D = %PlayerArea
@export var wilderness : Location
@onready var nav_agent: NavigationAgent2D = %NavAgent

const TRAVEL_SECTION_DISTANCE := 75.0
const MIN_SECTION_LENGTH := 25.0
const TRAVEL_SPEED := 150.0
const SECTION_PAUSE := 0.5

var traveling := false
var travel_index := 0
var traveled_distance := 0.0
var target_pos := Vector2.ZERO
var distance := 0.0
var price := 0
var paid_so_far := 0
var navigation_path: PackedVector2Array = PackedVector2Array()

func _ready() -> void:
	GlobalSignals.travel_suggestion.connect(_on_travel_suggestion)
	GlobalSignals.tab_clicked.connect(_on_tab_clicked)
	visible = false

func _physics_process(delta: float) -> void:
	if not traveling: return
	if travel_index >= path_line.points.size():
		_finish_section()
		return
	if traveled_distance >= TRAVEL_SECTION_DISTANCE:
		var remaining_distance := _get_remaining_path_distance()
		if remaining_distance > MIN_SECTION_LENGTH:
			_finish_section()
			return
	var next_point := path_line.points[travel_index]
	var previous_position := player.position
	player.position = player.position.move_toward(next_point, TRAVEL_SPEED * delta)
	traveled_distance += previous_position.distance_to(player.position)
	if player.position.is_equal_approx(next_point):
		player.position = next_point
		travel_index += 1

# =================================================================== path
func _on_tab_clicked(_index, titel):
	if titel != "Map": return
	visible = true
	player.position = LocationManager.get_player_pos()
	_hide_travel_preview()

func _on_travel_suggestion(new_target_pos: Vector2) -> void:
	if GameData.game_state != Enums.GAME_STATES.MAIN: return
	target_pos = to_local(new_target_pos)
	await _update_navigation(new_target_pos)
	if navigation_path.is_empty():
		_hide_travel_preview()
		return
	_update_path()
	_update_target_point()

func _update_navigation(new_target_pos: Vector2) -> void:
	nav_agent.target_position = new_target_pos
	await get_tree().physics_frame
	nav_agent.get_next_path_position()
	navigation_path = nav_agent.get_current_navigation_path()

func _update_path() -> void:
	path_line.clear_points()
	var last_point := Vector2.INF
	for global_point in navigation_path:
		if global_point.is_equal_approx(last_point):
			continue
		path_line.add_point(path_line.to_local(global_point))
		last_point = global_point
	path_line.visible = path_line.get_point_count() > 1

func _update_target_point():
	distance = _calculate_path_distance(navigation_path)
	price = floori(distance * GameData.COSTS.travel)

	travel_btn.text = "Cost: %s Gold" % price
	travel_btn.visible = true

	target_pos = to_local(nav_agent.get_final_position())
	target.position = target_pos
	target.visible = true

# =================================================================== travel
func _on_travel_btn_pressed() -> void:
	if path_line.points.size() < 2: 
		return
	travel_btn.visible = false
	GameData.game_state = Enums.GAME_STATES.TRAVEL
	traveling = true
	travel_index = 1
	traveled_distance = 0.0
	paid_so_far = 0

func _finish_section() -> void:
	traveling = false
	_pay_for_section()
	if AttributesManager.gold < 0 or travel_index >= path_line.points.size():
		_stop_travel()
		return
	_section_updates()
	await get_tree().create_timer(SECTION_PAUSE).timeout
	traveling = true

func _pay_for_section() -> void:
	var section_price := 0
	if travel_index >= path_line.points.size():
		section_price = maxi(price - paid_so_far, 0)
	else:
		section_price = floori(traveled_distance * GameData.COSTS.travel)
	AudioManager.play("coin")
	AttributesManager.gold -= section_price
	paid_so_far += section_price

func _section_updates() -> void:
	_update_player_position()
	LocationManager.check_for_random_event()
	traveled_distance = 0

func _stop_travel() -> void:
	GameData.game_state = GameData.old_game_state
	_update_player_position()
	_hide_travel_preview()

# ================================================ helper
func _calculate_path_distance(nav_path: PackedVector2Array) -> float:
	var total_distance := 0.0
	for index in range(1, nav_path.size()):
		var previous_point := nav_path[index - 1]
		var current_point := nav_path[index]
		if previous_point.is_equal_approx(current_point):
			continue
		total_distance += previous_point.distance_to(current_point)
	return total_distance

func _get_remaining_path_distance() -> float:
	var remaining := 0.0
	remaining += player.position.distance_to(path_line.points[travel_index])
	for index in range(travel_index +1, path_line.points.size()):
		remaining += path_line.points[index - 1].distance_to(
			path_line.points[index]
		)
	return remaining

func _hide_travel_preview() -> void:
	travel_btn.visible = false
	target.visible = false
	path_line.visible = false

func _update_player_position() -> void:
	LocationManager.player_pos = player.position
	for area in player_area.get_overlapping_areas():
		var marker := area.get_parent() as LocationMarker
		if marker == null or marker.location == null: continue
		LocationManager.current_location = marker.location
		return
	LocationManager.current_location = wilderness
