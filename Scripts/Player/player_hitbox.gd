extends Area2D


var damage_interval: float = 1.0
var damage_timer: float = 0.0
var current_damage: int = 0
var is_zombie_in_area: bool
var zombie_in_area: CharacterBody2D = null

@onready var player_script: CharacterBody2D = get_parent()


func _ready():
	player_script = get_parent()
	
	for zombie in get_tree().get_nodes_in_group("Zombie"):
		zombie.connect("zombie_died", _on_zombie_died)


func _process(delta):
	if is_zombie_in_area and zombie_in_area and not zombie_in_area.is_dead:
		damage_timer -= delta
		if damage_timer <= 0:
			damage_timer = damage_interval
			player_script.player_take_damage(current_damage)


func _on_zombie_died():
	is_zombie_in_area = false
	current_damage = 0


func _on_body_entered(body):
	if body.is_in_group("Zombie"):
		is_zombie_in_area = true
		zombie_in_area = body
		current_damage = body.damage_amount
		damage_timer = 0


func _on_body_exited(body):
	if body.is_in_group("Zombie"):
		is_zombie_in_area = false
		zombie_in_area = null
		current_damage = 0
