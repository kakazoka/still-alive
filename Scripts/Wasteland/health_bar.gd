extends TextureProgressBar


func _on_player_health_changed(new_health: int):
	var tween = create_tween()
	tween.tween_property(self, "value", new_health, 0.2)
