extends Area2D


@warning_ignore("unused_signal")
signal equipped_gun_changed(new_gun: String)
@warning_ignore("unused_signal")
signal total_gun_parts_changed(new_total_gun_parts: int)

const GUNS_COSTS = {
	"revolver": 250,
	"shotgun": 400,
	"machine_gun": 700,
	"sniper": 900,
	"rocket_launcher": 1500,
}

var equipped_gun: String

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var gun_shop_npc: AnimatedSprite2D = $GunShopNPCSprite
@onready var gun_shop_prompt: CanvasLayer = $GunShopNPCPrompt
@onready var dialogue_voice: AudioStreamPlayer2D = $GunShopNPCDialogueVoiceAudio
@onready var use_button_sound: AudioStreamPlayer2D = $GunShopNPCPrompt/UseButtonSound
@onready var unlock_button_sound: AudioStreamPlayer2D = $GunShopNPCPrompt/UnlockButtonSound
@onready var no_unlock_button_sound: AudioStreamPlayer2D = $GunShopNPCPrompt/NoUnlockButtonSound
@onready var close_button: Button = $GunShopNPCPrompt/CloseButton
@onready var close_button_sound: AudioStreamPlayer2D = $GunShopNPCPrompt/CloseButton/CloseButtonSound
@onready var pop_up: AnimatedSprite2D = $GunShopNPCSprite/PopUpSprite
@onready var guns: Dictionary = {
	"pistol": {
		"use_warning": $GunShopNPCPrompt/Pistol/PistolInUseWarning,
		"unlock_button": null,
		"use_button": $GunShopNPCPrompt/Pistol/PistolUseButton
	},
	"revolver": {
		"use_warning": $GunShopNPCPrompt/Revolver/RevolverInUseWarning,
		"unlock_button": $GunShopNPCPrompt/Revolver/RevolverUnlockButton,
		"use_button": $GunShopNPCPrompt/Revolver/RevolverUseButton
	},
	"shotgun": {
		"use_warning": $GunShopNPCPrompt/Shotgun/ShotgunInUseWarning,
		"unlock_button": $GunShopNPCPrompt/Shotgun/ShotgunUnlockButton,
		"use_button": $GunShopNPCPrompt/Shotgun/ShotgunUseButton
	},
	"machine_gun": {
		"use_warning": $GunShopNPCPrompt/MachineGun/MachineGunInUseWarning,
		"unlock_button": $GunShopNPCPrompt/MachineGun/MachineGunUnlockButton,
		"use_button": $GunShopNPCPrompt/MachineGun/MachineGunUseButton
	},
	"sniper": {
		"use_warning": $GunShopNPCPrompt/Sniper/SniperInUseWarning,
		"unlock_button": $GunShopNPCPrompt/Sniper/SniperUnlockButton,
		"use_button": $GunShopNPCPrompt/Sniper/SniperUseButton
	},
	"rocket_launcher": {
		"use_warning": $GunShopNPCPrompt/RocketLauncher/RocketLauncherInUseWarning,
		"unlock_button": $GunShopNPCPrompt/RocketLauncher/RocketLauncherUnlockButton,
		"use_button": $GunShopNPCPrompt/RocketLauncher/RocketLauncherUseButton
	}
}


func _ready():
	gun_shop_prompt.visible = false


func _on_body_entered(body):
	if body.is_in_group("Player"):
		_show_prompt()
		_update_prompt_interface()


func _on_body_exited(body):
	if body.is_in_group("Player"):
		_hide_prompt()


func _on_close_button_pressed():
	close_button_sound.play()
	
	_hide_prompt()
	
	player.global_position += Vector2(-50, 0)


func _on_revolver_unlock_button_pressed():
	_unlock_weapon("revolver", 250, unlock_button_sound)

func _on_shotgun_unlock_button_pressed():
	_unlock_weapon("shotgun", 400, unlock_button_sound)

func _on_machine_gun_unlock_button_pressed():
	_unlock_weapon("machine_gun", 700, unlock_button_sound)

func _on_sniper_unlock_button_pressed():
	_unlock_weapon("sniper", 900, unlock_button_sound)

func _on_rocket_launcher_unlock_button_pressed():
	_unlock_weapon("rocket_launcher", 1500, unlock_button_sound)


func _on_pistol_use_button_pressed():
	_use_weapon("pistol", use_button_sound)

func _on_revolver_use_button_pressed():
	_use_weapon("revolver", use_button_sound)

func _on_shotgun_use_button_pressed():
	_use_weapon("shotgun", use_button_sound)

func _on_machine_gun_use_button_pressed():
	_use_weapon("machine_gun", use_button_sound)

func _on_sniper_use_button_pressed():
	_use_weapon("sniper", use_button_sound)

func _on_rocket_launcher_use_button_pressed():
	_use_weapon("rocket_launcher", use_button_sound)


func _show_prompt():
	gun_shop_prompt.visible = true
	
	dialogue_voice.play()
	
	pop_up.set_prompt_active(true)
	
	gun_shop_npc.play("Talk")
	
	player.can_move = false
	player.is_prompt_active = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _hide_prompt():
	gun_shop_prompt.visible = false
	
	pop_up.set_prompt_active(false)
	
	gun_shop_npc.play("Idle")
	
	player.can_move = true
	player.is_prompt_active = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _update_prompt_interface():
	var owned_weapons = {
		"pistol": true,
		"revolver": PlayerVariables.has_revolver,
		"shotgun": PlayerVariables.has_shotgun,
		"machine_gun": PlayerVariables.has_machine_gun,
		"sniper": PlayerVariables.has_sniper,
		"rocket_launcher": PlayerVariables.has_rocket_launcher,
	}

	for gun in guns.keys():
		var nodes = guns[gun]
		var is_equipped = PlayerVariables.equipped_gun == gun
		var is_owned = owned_weapons.get(gun, false)

		nodes["use_warning"].visible = is_owned and is_equipped
		nodes["use_button"].visible = is_owned and not is_equipped
		if nodes.has("unlock_button") and nodes["unlock_button"] != null:
			nodes["unlock_button"].visible = not is_owned


func _unlock_weapon(gun: String, cost: int, sound: AudioStreamPlayer2D):
	if GlobalVariables.total_gun_parts >= cost:
		GlobalVariables.total_gun_parts -= cost
		sound.play()
		emit_signal("total_gun_parts_changed", GlobalVariables.total_gun_parts)

		match gun:
			"revolver": PlayerVariables.has_revolver = true
			"shotgun": PlayerVariables.has_shotgun = true
			"machine_gun": PlayerVariables.has_machine_gun = true
			"sniper": PlayerVariables.has_sniper = true
			"rocket_launcher": PlayerVariables.has_rocket_launcher = true

		_update_prompt_interface()
	else:
		no_unlock_button_sound.play()


func _use_weapon(gun: String, sound: AudioStreamPlayer2D):
	var is_unlocked := false

	match gun:
		"pistol": is_unlocked = true  # always available
		"revolver": is_unlocked = PlayerVariables.has_revolver
		"shotgun": is_unlocked = PlayerVariables.has_shotgun
		"machine_gun": is_unlocked = PlayerVariables.has_machine_gun
		"sniper": is_unlocked = PlayerVariables.has_sniper
		"rocket_launcher": is_unlocked = PlayerVariables.has_rocket_launcher

	if is_unlocked:
		sound.play()
		PlayerVariables.equipped_gun = gun
		emit_signal("equipped_gun_changed", gun)
		_update_prompt_interface()
	else:
		no_unlock_button_sound.play()
