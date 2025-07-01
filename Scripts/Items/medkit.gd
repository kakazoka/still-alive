extends Area2D


@onready var item_type: String = "medkit"
@onready var medkit_collect_sound: AudioStreamPlayer2D = $MedkitCollectSound


func _on_body_entered(body: CharacterBody2D):
	if body.is_in_group("Player"):
		medkit_collect_sound.play()
		body.collect_item(self)
		await get_tree().create_timer(0.2).timeout
		queue_free()


func _on_queue_free_timer_timeout():
	queue_free()
