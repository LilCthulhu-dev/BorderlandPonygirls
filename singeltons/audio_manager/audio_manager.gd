extends Node

var rng = RandomNumberGenerator.new()

func play(effect_name : String, pitch_rng = 0.2, volume = -100.0):
	var player : AudioStreamPlayer = get_node(effect_name)
	if not player:
		push_warning('audio player not found')
		return
	if volume != -100:
		player.volume_db = volume
	if pitch_rng != 0.0:
		var min_pitch = 1.0 - pitch_rng
		var max_pitch = 1.0 + pitch_rng
		player.pitch_scale = rng.randf_range(min_pitch, max_pitch)
	player.play()
