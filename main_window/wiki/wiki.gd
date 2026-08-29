extends StoryPage

@onready var list_container: VBoxContainer = %ListContainer
@onready var entry_header: Label = %EntryHeader
@onready var entry_image: TextureRect = %EntryImage
@onready var entry_description: RichTextLabel = %EntryDescription

@export_dir var wiki_entries_folder := "res://data/wiki_entries/"
var wiki_entries : Array[WikiEntry] = []
var wiki_btn_bp: PackedScene = preload("uid://chkoq2y0c64um")

var _selected_entry: WikiEntry


func _ready() -> void:
	super()
	GlobalSignals.wiki_entry_selected.connect(_on_entry_selected)
	if GlobalSignals and not GlobalSignals.language_changed.is_connected(_refresh_language):
		GlobalSignals.language_changed.connect(_refresh_language)
	_get_all_entries()
	_remove_sub_entries(wiki_entries)
	_sort_entries(wiki_entries)
	_add_entries()
	_refresh_search_label()
	if not wiki_entries.is_empty():
		_on_entry_selected(wiki_entries[0])


func _get_all_entries() -> void:
	wiki_entries.clear()
	for file_name in ResourceLoader.list_directory(wiki_entries_folder):
		if file_name.ends_with("/"):
			continue
		if file_name.get_extension() not in ["tres", "res"]:
			continue
		var path := wiki_entries_folder.path_join(file_name)
		var resource := ResourceLoader.load(path)
		if resource is WikiEntry:
			wiki_entries.append(resource)


func _remove_sub_entries(entries: Array[WikiEntry]) -> void:
	var sub_entries: Array[WikiEntry] = []
	for entry in entries:
		for sub_entry in entry.sub_entries:
			if not sub_entries.has(sub_entry):
				sub_entries.append(sub_entry)
	for sub_entry in sub_entries:
		entries.erase(sub_entry)


func _sort_entries(entries: Array[WikiEntry]) -> void:
	entries.sort_custom(
		func(a: WikiEntry, b: WikiEntry) -> bool:
			return a.titel.naturalnocasecmp_to(b.titel) < 0
	)


func _add_entries() -> void:
	for wiki_entry in wiki_entries:
		var btn = wiki_btn_bp.instantiate()
		btn.wiki_entry = wiki_entry
		list_container.add_child(btn)
		for sub_entry in wiki_entry.sub_entries:
			var sub_btn = wiki_btn_bp.instantiate()
			sub_btn.wiki_entry = sub_entry
			sub_btn.sub_btn = true
			list_container.add_child(sub_btn)


func _refresh_search_label() -> void:
	var search_label := get_node_or_null("VBoxContainer/HBoxContainer/Label") as Label
	if search_label:
		Utils.set_dynamic_label(search_label, "Search:")


func _refresh_language() -> void:
	_refresh_search_label()
	if _selected_entry:
		_on_entry_selected(_selected_entry)


func _on_entry_selected(wiki_entry: WikiEntry) -> void:
	_selected_entry = wiki_entry
	Utils.set_dynamic_label(entry_header, wiki_entry.titel)
	Utils.set_dynamic_label(entry_description, wiki_entry.description)
	entry_image.texture = wiki_entry.img
	entry_image.visible = wiki_entry.img is Texture2D


func _on_wiki_search_text_changed(new_text: String) -> void:
	var search_text := new_text.strip_edges().to_lower()
	for child in list_container.get_children():
		if child is not WikiBtn:
			continue
		var title: String = child.wiki_entry.titel.to_lower()
		var translated: String = Utils.translate(child.wiki_entry.titel).to_lower()
		var has_fitting_sub_entry := false
		for sub_entry in child.wiki_entry.sub_entries:
			if (
				sub_entry.titel.to_lower().contains(search_text)
				or Utils.translate(sub_entry.titel).to_lower().contains(search_text)
			):
				has_fitting_sub_entry = true
				break
		child.visible = (
			search_text.is_empty()
			or title.contains(search_text)
			or translated.contains(search_text)
			or has_fitting_sub_entry
		)
