extends Area2D


@onready var item_type: String = "gun_part"
@onready var gun_part_collect_sound: AudioStreamPlayer2D = $GunPartCollectSound


func _on_body_entered(body):
	if body.is_in_group("Player"):
		gun_part_collect_sound.play()
		body.collect_item(self)
		await get_tree().create_timer(0.2).timeout
		queue_free()


func _on_queue_free_timer_timeout():
	queue_free()
