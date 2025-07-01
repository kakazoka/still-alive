extends Area2D


@export var health: int = 100

@onready var zombie_sprite: AnimatedSprite2D = get_parent().get_node("ZombieThreeSprite")
@onready var zombie_script: CharacterBody2D = get_parent()


func _die():
	zombie_script.stop_movement()
	zombie_sprite.play("Death")


func zombie_take_damage(amount: int):
	if health > 0:
		health -= amount
		zombie_script.zombie_hit()
		
		if health <= 0:
			_die()
