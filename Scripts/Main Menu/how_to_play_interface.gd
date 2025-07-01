extends CanvasLayer


@onready var close_button_sound: AudioStreamPlayer2D = $CloseButton/CloseButtonSound


func _ready():
	visible = false


func _on_close_button_pressed():
	close_button_sound.play()
	
	visible = false
