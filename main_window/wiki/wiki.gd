extends StoryPage

@onready var list_container: VBoxContainer = %ListContainer
@onready var entry_header: Label = %EntryHeader
@onready var entry_image: TextureRect = %EntryImage
@onready var entry_description: Label = %EntryDescription

@export var wiki_entries : Array[WikiEntry]
var wiki_btn_bp = preload("uid://chkoq2y0c64um")

func _ready() -> void:
	super()
	GlobalSignals.wiki_entry_selected.connect(_on_entry_selected)
	for wiki_entry in wiki_entries:
		var btn = wiki_btn_bp.instantiate()
		btn.wiki_entry = wiki_entry
		list_container.add_child(btn)
		for sub_entry in wiki_entry.sub_entries:
			var sub_btn = wiki_btn_bp.instantiate()
			sub_btn.wiki_entry = sub_entry
			sub_btn.sub_btn = true
			list_container.add_child(sub_btn)
	_on_entry_selected(wiki_entries[0])


func _on_entry_selected(wiki_entry : WikiEntry):
	entry_header.text = wiki_entry.titel
	entry_image.visible = wiki_entry.img is Texture2D
	if entry_image.visible:
		entry_image.texture = wiki_entry.img
	entry_description.text = wiki_entry.description
