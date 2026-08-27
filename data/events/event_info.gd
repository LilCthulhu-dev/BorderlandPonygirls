extends _EventContent
class_name EventInfo

@export var btn_text := ""
@export var single_use = false
@export var end_conversation = false

@export_multiline var description := ""
@export var actions : Array[Action]

# @export_group('Optional: Test')
# @export var ability : Enums.ABILITIES
# @export var modifier := 0
# @export_multiline var fail_description := ""
# @export var fail_actions : Array[Action]
