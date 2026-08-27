@tool
extends EditorScript

const EVENTS_DIRECTORY := "res://data/events"


func _run() -> void:
	var paths: Array[String] = []
	_find_tres_files(EVENTS_DIRECTORY, paths)

	var migrated := 0

	for path in paths:
		var resource := ResourceLoader.load(
			path,
			"",
			ResourceLoader.CACHE_MODE_REPLACE
		)

		if resource is not Event:
			continue

		var file := FileAccess.open(path, FileAccess.READ)

		if file == null:
			push_error("Konnte Datei nicht lesen: %s" % path)
			continue

		var content := file.get_as_text()
		file.close()

		var regex := RegEx.new()
		regex.compile("(?m)^description\\s*=")

		if not regex.search(content):
			continue

		content = regex.sub(
			content,
			"_description =",
			true
		)

		file = FileAccess.open(path, FileAccess.WRITE)

		if file == null:
			push_error("Konnte Datei nicht schreiben: %s" % path)
			continue

		file.store_string(content)
		file.close()

		print("Migriert: ", path)
		migrated += 1

	print("Migration abgeschlossen: %d Events" % migrated)


func _find_tres_files(
	directory_path: String,
	results: Array[String]
) -> void:
	var directory := DirAccess.open(directory_path)

	if directory == null:
		push_error("Ordner nicht gefunden: %s" % directory_path)
		return

	directory.list_dir_begin()

	var entry := directory.get_next()

	while not entry.is_empty():
		var path := directory_path.path_join(entry)

		if directory.current_is_dir():
			_find_tres_files(path, results)
		elif entry.get_extension().to_lower() == "tres":
			results.append(path)

		entry = directory.get_next()

	directory.list_dir_end()