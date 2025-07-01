extends CanvasLayer


@onready var resume_button_sound: AudioStreamPlayer2D = $ResumeButton/ResumeButtonSound
@onready var quit_button_sound: AudioStreamPlayer2D = $QuitButton/QuitButtonSound
@onready var pause_menu_animation: AnimationPlayer = $"../PauseMenuAnimation"


func _ready():
	hide()
	
	pause_menu_animation.play("RESET")


func _process(_delta):
	_check_pause()


func _on_resume_button_pressed():
	_resume()


func _on_quit_button_pressed():
	quit_button_sound.play()
	
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()


func _check_pause():
	if Input.is_action_just_pressed("Pause") and get_tree().paused == false:
		_pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused == true:
		_resume()


func _pause():
	show()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	pause_menu_animation.play("blur")
	
	get_tree().paused = true


func _resume():
	hide()
	
	resume_button_sound.play()
	
	pause_menu_animation.play_backwards("blur")
	
	await get_tree().create_timer(0.3).timeout
	get_tree().paused = false
