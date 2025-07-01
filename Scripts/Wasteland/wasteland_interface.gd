extends CanvasLayer


func _ready():
	visible = false
	
	await get_tree().create_timer(0.1).timeout
	visible = true


func _on_main_menu_button_pressed():
	await get_tree().create_timer(0.3).timeout
	visible = false


func _on_continue_button_pressed():
	await get_tree().create_timer(0.3).timeout
	visible = false
