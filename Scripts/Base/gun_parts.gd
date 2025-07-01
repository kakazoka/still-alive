extends Label


func _ready():
	text = str(GlobalVariables.total_gun_parts)


func _on_gun_shop_npc_total_gun_parts_changed(new_total_gun_parts: int):
	text = str(new_total_gun_parts)
