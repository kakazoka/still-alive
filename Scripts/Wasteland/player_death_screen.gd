extends CanvasLayer


@onready var wasteland_music: AudioStreamPlayer = $"../WastelandMusic"
@onready var wave_counter: Label = $"../WastelandInterface/WaveCount/WaveCounter"
@onready var survival_timer: Label = $"../WastelandInterface/SurvivalTime/SurvivalTimer" 
@onready var kill_counter: Label = $"../WastelandInterface/KillCount/KillCounter"
@onready var gun_part_counter: Label = $"../WastelandInterface/GunPartCount/GunPartCounter"
@onready var wave_counter_label: Label = $WavesSurvived/WavesSurvivedValue
@onready var survival_timer_label: Label = $TimeSurvived/TimeSurvivedValue
@onready var kill_counter_label: Label = $ZombiesKilled/ZombiesKilledValue
@onready var gun_part_counter_label: Label = $GunParts/GunPartsCollectedValue
@onready var player_death_screen_music: AudioStreamPlayer = $PlayerDeathScreenMusic
@onready var main_menu_button_sound: AudioStreamPlayer2D = $MainMenuButton/MainMenuButtonSound
@onready var continue_button_sound: AudioStreamPlayer2D = $ContinueButton/ContinueButtonSound


func _ready():
	visible = false


func _on_player_player_died():
	visible = true
	
	player_death_screen_music.play()
	wasteland_music.stop()
	
	wave_counter_label.text = wave_counter.text.replace("Wave", "").strip_edges()
	survival_timer_label.text = survival_timer.text
	kill_counter_label.text = kill_counter.text
	gun_part_counter_label.text = gun_part_counter.text


func _on_player_death_screen_main_menu_button_pressed():
	main_menu_button_sound.play()
	
	await get_tree().create_timer(0.3).timeout
	visible = false
	Transitions.transition()
	
	await Transitions.transition_finished
	if SceneManager.main_menu_scene:
		get_tree().change_scene_to_packed(SceneManager.main_menu_scene)


func _on_player_death_screen_continue_button_pressed():
	continue_button_sound.play()
	
	await get_tree().create_timer(0.3).timeout
	visible = false
	Transitions.transition()
	
	await Transitions.transition_finished
	if SceneManager.base_scene:
		get_tree().change_scene_to_packed(SceneManager.base_scene)
