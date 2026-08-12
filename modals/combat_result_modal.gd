extends Modal

@onready var header: Label = %Header
@onready var description: Label = %Description

var action : CombatAction
var success : bool = false

func _ready() -> void:
	success = action.check()
	if success:
		AudioManager.play('success2')
	else:
		AudioManager.play('fail2')
	if success:
		header.text = "Success"
		description.text = action.success_description
		description.text += "\n\n"
		description.text += "- Enemy loses 1 health."
		CombatManager.action_success()
	else:
		header.text = "Failure"
		description.text = action.fail_description
		description.text += "\n\n"
		description.text += "- You lose 1 health."
		CombatManager.action_failure()
	description.text = Utils.translate(description.text)
	super()

func close() -> void:
	super()
	GlobalSignals.update_combat.emit()

func _on_next_btn_pressed() -> void:
	close()
