@tool
extends EditorScript

const EVENTS_FOLDER := "res://data/events/"


func _run() -> void:
	var files := _find_resource_files(EVENTS_FOLDER)

	var changed_files := 0
	var converted_buttons := 0
	var skipped_buttons := 0

	for path in files:
		var resource := ResourceLoader.load(path)

		if resource is not Event:
			continue

		var result := _migrate_event(resource as Event)

		converted_buttons += result.converted
		skipped_buttons += result.skipped

		if result.converted == 0:
			continue

		var error := ResourceSaver.save(resource, path)

		if error != OK:
			push_error("Konnte Datei nicht speichern: %s" % path)
			continue

		changed_files += 1
		print("Migriert: %s" % path)

	print("")
	print("Migration abgeschlossen.")
	print("Geänderte Dateien: %s" % changed_files)
	print("Umgewandelte EventBtn: %s" % converted_buttons)
	print("Wegen rng_text übersprungen: %s" % skipped_buttons)


func _migrate_event(event: Event) -> Dictionary:
	var converted := 0
	var skipped := 0

	for index in event.content.size():
		var event_btn := event.content[index]

		if event_btn is not EventBtn:
			continue

		var add_description: AddDescription = null

		for action in event_btn.actions:
			if action is AddDescription:
				add_description = action
				break

		if add_description == null:
			continue

		if not add_description.rng_text.is_empty():
			skipped += 1
			continue

		var event_info := EventModalInfo.new()

		event_info._btn_text = event_btn.txt
		event_info._modal_text = add_description.txt

		for action in event_btn.actions:
			if action is AddDescription:
				continue

			event_info.actions.append(action)

		event.content[index] = event_info
		converted += 1

	return {
		"converted": converted,
		"skipped": skipped,
	}


func _find_resource_files(folder: String) -> Array[String]:
	var files: Array[String] = []
	var directory := DirAccess.open(folder)

	if directory == null:
		push_error("Ordner konnte nicht geöffnet werden: %s" % folder)
		return files

	directory.list_dir_begin()

	var entry := directory.get_next()

	while not entry.is_empty():
		var path := folder.path_join(entry)

		if directory.current_is_dir():
			files.append_array(_find_resource_files(path))
		elif entry.get_extension() in ["tres", "res"]:
			files.append(path)

		entry = directory.get_next()

	directory.list_dir_end()
	return files