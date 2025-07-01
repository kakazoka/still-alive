extends Area2D


@onready var wasteland_prompt: CanvasLayer = $WastelandNPCPrompt
@onready var dialogue_voice: AudioStreamPlayer2D = $WastelandNPCDialogueVoiceAudio
@onready var yes_button: Button = $WastelandNPCPrompt/YesButton
@onready var yes_button_sound: AudioStreamPlayer2D = $WastelandNPCPrompt/YesButton/YesButtonSound
@onready var no_button: Button = $WastelandNPCPrompt/NoButton
@onready var no_button_sound: AudioStreamPlayer2D = $WastelandNPCPrompt/NoButton/NoButtonSound
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var wasteland_npc: AnimatedSprite2D = $WastelandNPCSprite
@onready var pop_up: AnimatedSprite2D = $WastelandNPCSprite/PopUpSprite


func _ready():
	wasteland_prompt.visible = false


func _on_body_entered(body):
	if body.is_in_group("Player"):
		wasteland_prompt.visible = true
		dialogue_voice.play()
		pop_up.set_prompt_active(true)
		wasteland_npc.play("Talk")
		body.can_move = false
		player.is_prompt_active = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_body_exited(body):
	if body.is_in_group("Player"):
		wasteland_prompt.visible = false
		pop_up.set_prompt_active(false)
		wasteland_npc.play("Idle")
		body.can_move = true
		player.is_prompt_active = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_wasteland_prompt_yes_button_pressed():
	yes_button_sound.play()
	
	await get_tree().create_timer(0.3).timeout
	
	Transitions.transition()
	
	await Transitions.transition_finished
	
	if SceneManager.wasteland_scene:
		get_tree().change_scene_to_packed(SceneManager.wasteland_scene)


func _on_wasteland_prompt_no_button_pressed():
	no_button_sound.play()
	wasteland_prompt.visible = false
	player.can_move = true
	player.global_position += Vector2(0, 50)
