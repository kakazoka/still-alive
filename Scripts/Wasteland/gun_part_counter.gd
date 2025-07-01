extends Label


var gun_parts_collected: int = 0

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")


func _ready():
	player.connect("gun_part_collected", Callable(self, "_on_gun_part_collected"))


func _on_gun_part_collected():
	gun_parts_collected += 1
	text = str(gun_parts_collected)
