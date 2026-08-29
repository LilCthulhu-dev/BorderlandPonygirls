@tool
extends EditorScript

const EVENTS_FOLDER := "res://data/events/"

func _run() -> void:
	_change_and_save_event_btns()

func _change_and_save_event_btns(folder := EVENTS_FOLDER) -> void:
	var dir := DirAccess.open(folder)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while not file_name.is_empty():
		var path := folder.path_join(file_name)
		if dir.current_is_dir():
			_change_and_save_event_btns(path)
		elif file_name.get_extension() in ["tres", "res"]:
			var resource := ResourceLoader.load(path)
			if resource is Event:
				var changed := false
				for content in resource.content:
					if content is EventBtn:
						content._btn_text = content.txt
						changed = true
				if changed:
					ResourceSaver.save(resource, path)
					print("Migriert: %s" % path)
		file_name = dir.get_next()
	dir.list_dir_end()
