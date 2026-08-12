extends Action
class_name FocusPonygirl

enum TARGET {
	ACTIVE,
	RESTING,
	ALL,
}

@export var target := TARGET.ACTIVE

func use() -> void:
	match target:
		TARGET.ACTIVE:
			PonygirlManager.focused_ponygirl = PonygirlManager.get_random_active_ponygirl()
		TARGET.RESTING:
			PonygirlManager.focused_ponygirl = PonygirlManager.get_random_resting_ponygirl()
		TARGET.ALL:
			PonygirlManager.focused_ponygirl = PonygirlManager.ponygirls.pick_random()

func requirement_met() -> bool:
	match target:
		TARGET.ACTIVE:
			return !PonygirlManager.get_active_ponygirls().is_empty()
		TARGET.RESTING:
			return !PonygirlManager.get_resting_ponygirls().is_empty()
		TARGET.ALL:
			return !PonygirlManager.ponygirls.is_empty()
		_:
			return false
