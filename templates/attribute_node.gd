extends HBoxContainer

@onready var icon: TextureRect = %Icon
@onready var value: Label = %Value
@export var attribute := Enums.ATTRIBUTES.MUSCLE

func _ready():
	GlobalSignals.update_attribute.connect(_update_value)
	GlobalSignals.update_ponygirls.connect(_update_value)
	icon.texture = AttributesManager.get_attribute_icon(attribute)
	_update_value()

func _update_value():
	match attribute:
		Enums.ATTRIBUTES.GOLD:
			value.text = "%s" % AttributesManager.gold
		Enums.ATTRIBUTES.REPUTE:
			value.text = "%s (%s)" % [AttributesManager.get_modified_repute(), AttributesManager.repute]
		Enums.ATTRIBUTES.HEALTH:
			value.text = "%s/%s" % [AttributesManager.current_health, AttributesManager.MAX_HEALTH]
		Enums.ATTRIBUTES.MUSCLE:
			value.text = "%s" % AttributesManager.muscle
		Enums.ATTRIBUTES.SWAY:
			value.text = "%s" % AttributesManager.sway
		Enums.ATTRIBUTES.COMMAND:
			value.text = "%s" % AttributesManager.command
		Enums.ATTRIBUTES.TRICKERY:
			value.text = "%s" % AttributesManager.trickery
		Enums.ATTRIBUTES.WITS:
			value.text = "%s" % AttributesManager.wits
		Enums.ATTRIBUTES.WEIGHT:
			value.text = "%s/%s" % [InventoryManager.current_weight, InventoryManager.MAX_WEIGHT]

func _on_mouse_entered() -> void:
	var txt = Enums.ATTRIBUTES.keys()[attribute].capitalize()
	if AttributesManager.get_attribute_description(attribute) != "":
		txt += "\n%s" % AttributesManager.get_attribute_description(attribute)
	TooltipManager.add(txt)

func _on_mouse_exited() -> void:
	TooltipManager.remove()
