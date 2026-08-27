extends Action
class_name Heal

func use() -> void:
	super()
	AttributesManager.current_health = AttributesManager.MAX_HEALTH

func requirement_met() -> bool:
	return AttributesManager.current_health < AttributesManager.MAX_HEALTH

func _get_txt() -> String:
	return "Fully restores Health."
