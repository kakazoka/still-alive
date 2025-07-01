extends CharacterBody2D


@export var speed: float = 20.0

var direction: Vector2 = Vector2.ZERO
var change_timer: float = 0.0

@onready var zombie_sprite: AnimatedSprite2D = $ZombieTwoSprite


func _ready():
	randomize()
	_change_direction()


func _process(delta):
	change_timer -= delta
	if change_timer <= 0:
		_change_direction()
	
	velocity = direction * speed
	move_and_slide()
	
	if direction.x > 0:
		zombie_sprite.flip_h = true
	else:
		zombie_sprite.flip_h = false


func _change_direction():
	direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	change_timer = randf_range(1.0, 10.0)
