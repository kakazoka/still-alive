extends CanvasLayer


func _ready():
	visible = false
	
	await get_tree().create_timer(0.1).timeout
	visible = true
