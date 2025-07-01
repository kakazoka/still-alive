extends CanvasLayer


@onready var new_game_button_sound: AudioStreamPlayer2D = $NewGameButton/NewGameButtonSound
@onready var continue_button_sound: AudioStreamPlayer2D = $ContinueButton/ContinueButtonSound
@onready var quit_button_sound: AudioStreamPlayer2D = $QuitButton/QuitButtonSound
@onready var how_to_play_button_sound: AudioStreamPlayer2D = $HowToPlayButton/HowToPlayButtonSound
@onready var how_to_play_interface: CanvasLayer = $"../HowToPlayInterface"


func _on_new_game_button_pressed():
	new_game_button_sound.play()
	
	ProgressManager.new_game()
	
	await get_tree().create_timer(0.3).timeout
	Transitions.transition()
	
	await Transitions.transition_finished
	if SceneManager.base_scene:
		get_tree().change_scene_to_packed(SceneManager.base_scene)


func _on_continue_button_pressed():
	continue_button_sound.play()
	
	if FileAccess.file_exists("user://SaveFile.json"):
		ProgressManager.load()
		
		await get_tree().create_timer(0.3).timeout
		Transitions.transition()
		
		await Transitions.transition_finished
		if SceneManager.base_scene:
			get_tree().change_scene_to_packed(SceneManager.base_scene)


func _on_quit_button_pressed():
	quit_button_sound.play()
	
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()


func _on_how_to_play_button_pressed():
	how_to_play_button_sound.play()
	
	how_to_play_interface.visible = true
