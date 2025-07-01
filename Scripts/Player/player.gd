extends CharacterBody2D


@warning_ignore("unused_signal")
signal player_died
@warning_ignore("unused_signal")
signal health_changed(new_health: int)
@warning_ignore("unused_signal")
signal gun_part_collected

@export var bullet_scene: PackedScene
@export var explosion_scene: PackedScene
@export var health: int = 100
@export var max_health: int = 100
@export var speed: int = 200
@export var damage_voices: Array[AudioStreamPlayer2D]
@export var death_voices: Array[AudioStreamPlayer2D]
@export var trigger_frames: Array[int] = [2, 7]
@export var base_footsteps_sounds: Array[AudioStreamPlayer2D]
@export var wasteland_footsteps_sounds: Array[AudioStreamPlayer2D]

var equipped_gun: String
var is_dead: bool
var can_shoot: bool
var can_move: bool
var has_revolver: bool
var has_shotgun: bool
var has_machine_gun: bool
var has_sniper: bool
var has_rocket_launcher: bool
var is_prompt_active: bool
var guns_damage: Dictionary = {
	"pistol": 10,
	"revolver": 20,
	"shotgun": 30,
	"machine_gun": 25,
	"sniper": 50,
	"rocket_launcher": 100
}

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var pistol_shoot_sound: AudioStreamPlayer2D = $Guns/Pistol/PistolShootSound
@onready var revolver_shoot_sound: AudioStreamPlayer2D = $Guns/Revolver/RevolverShootSound
@onready var shotgun_shoot_sound: AudioStreamPlayer2D = $Guns/Shotgun/ShotgunShootSound
@onready var machine_gun_shoot_sound: AudioStreamPlayer2D = $Guns/MachineGun/MachineGunShootSound
@onready var sniper_shoot_sound: AudioStreamPlayer2D = $Guns/Sniper/SniperShootSound
@onready var rocket_launcher_shoot_sound: AudioStreamPlayer2D = $Guns/RocketLauncher/RocketLauncherShootSound
@onready var guns: Dictionary = {
	"pistol": $Guns/Pistol,
	"revolver": $Guns/Revolver,
	"shotgun": $Guns/Shotgun,
	"machine_gun": $Guns/MachineGun,
	"sniper": $Guns/Sniper,
	"rocket_launcher": $Guns/RocketLauncher
}
@onready var guns_shoot_sounds: Dictionary = {
	"pistol": pistol_shoot_sound,
	"revolver": revolver_shoot_sound,
	"shotgun": shotgun_shoot_sound,
	"machine_gun": machine_gun_shoot_sound,
	"sniper": sniper_shoot_sound,
	"rocket_launcher": rocket_launcher_shoot_sound
}


func _ready():
	is_dead = false
	can_shoot = true
	can_move = true
	
	equipped_gun = PlayerVariables.equipped_gun
	
	has_revolver = PlayerVariables.has_revolver
	has_shotgun = PlayerVariables.has_shotgun
	has_machine_gun = PlayerVariables.has_machine_gun
	has_sniper = PlayerVariables.has_sniper
	has_rocket_launcher = PlayerVariables.has_rocket_launcher
	
	is_prompt_active = false
	
	if get_tree().current_scene.name == "Base":
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(_delta):
	if is_dead:
		return
	
	var mouse_position = get_global_mouse_position()
	
	_update_player_animation()
	_flip_player_sprite(mouse_position)
	_update_gun_direction(mouse_position)
	
	for gun in guns.keys():
		guns[gun].visible = (gun == equipped_gun and get_tree().current_scene.name != "Base")
	
	if get_tree().current_scene.name != "Base" and Input.is_action_pressed("Shoot") and can_shoot and guns.has(equipped_gun):
		_shoot()


func _physics_process(_delta):
	if is_dead:
		velocity = Vector2.ZERO
		return
		
	if can_move:
		var direction = Input.get_vector("Left", "Right", "Up", "Down")
		velocity = direction * speed
		
		move_and_slide()


func _on_gun_shop_npc_equipped_gun_changed(new_gun: String):
	PlayerVariables.equipped_gun = new_gun


func _on_gun_animation_finished():
	can_shoot = true


func _update_player_animation():
	if Input.get_vector("Left", "Right", "Up", "Down"):
		player_sprite.play("Run")
		
		if player_sprite.frame in trigger_frames and get_tree().current_scene.name == "Base" and base_footsteps_sounds:
			var random_index = randi_range(0, base_footsteps_sounds.size() - 1)
			base_footsteps_sounds[random_index].play()
		elif player_sprite.frame in trigger_frames and get_tree().current_scene.name == "Wasteland" and wasteland_footsteps_sounds:
			var random_index = randi_range(0, wasteland_footsteps_sounds.size() -1)
			wasteland_footsteps_sounds[random_index].play()
		
	else:
		player_sprite.play("Idle")


func _flip_player_sprite(mouse_position):
	if is_prompt_active:
		return
		
	player_sprite.flip_h = mouse_position.x > global_position.x


func _update_gun_direction(mouse_position):
	var gun = guns[equipped_gun]
	gun.visible = true
	
	gun.look_at(mouse_position)
	gun.scale.y = 1 if mouse_position.x > global_position.x else -1
	
	if Input.is_action_pressed("Shoot"):
		gun.play("Shoot")


func _shoot():
	if not can_shoot:
		return
		
	can_shoot = false
	
	if equipped_gun in guns_shoot_sounds:
		guns_shoot_sounds[equipped_gun].play()
	
	if equipped_gun == "rocket_launcher":
		_instantiate_explosion(guns_damage[equipped_gun])
	else:
		_instantiate_bullet(guns_damage[equipped_gun])


func _instantiate_bullet(damage: int):
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	
	get_parent().add_child(bullet)
	
	bullet.bullet_direction(get_global_mouse_position())
	bullet.set_damage(damage)


func _instantiate_explosion(damage: int):
	var explosion = explosion_scene.instantiate()
	explosion.position = global_position
	
	get_parent().add_child(explosion)
	
	explosion.explosion_direction(get_global_mouse_position())
	explosion.set_damage(damage)


func _heal():
	var heal_amount: int = randi_range(10, 20)
	health = min(health + heal_amount, max_health)
	emit_signal("health_changed", health)


func _die():
	is_dead = true
	emit_signal("player_died")
	
	ProgressManager.save_on_player_death()
	
	for gun in guns.values():
		gun.visible = false
	
	player_sprite.play("Death")
	if death_voices:
		death_voices[randi_range(0, death_voices.size() - 1)].play()


func player_take_damage(amount: int):
	if health > 0:
		health -= amount
		emit_signal("health_changed", health)
		
		player_sprite.stop()
		player_sprite.play("Hit")
		
		if damage_voices:
			var random_index = randi_range(0, damage_voices.size() -1)
			damage_voices[random_index].play()
		
		if health <= 0:
			_die()


func collect_item(item: Node):
	if item.item_type == "gun_part":
		emit_signal("gun_part_collected")
		GlobalVariables.total_gun_parts += 1
	elif item.item_type == "medkit":
		_heal()
