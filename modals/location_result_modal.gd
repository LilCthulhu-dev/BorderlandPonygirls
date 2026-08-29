extends Modal

@onready var titel_label: Label = %TitelLabel
@onready var results_label: Label = %ResultsLabel
var titel := "Results"
var results : Array[String] = []

func _ready() -> void:
	super()
	titel_label.text = Utils.translate(titel)
	for result in results:
		if results_label.text != "": results_label.text += "\n"
		results_label.text += result

func _on_button_pressed() -> void:
	close()
