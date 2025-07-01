extends Area2D


@export var bullet_speed: int = 400
@export var maximum_distance: int = 1000

var bullet_velocity: Vector2 = Vector2.ZERO
var damage: int = 0
var distance_traveled: int = 0
var has_impact_occurred: bool = false

@onready var bullet_sprite: AnimatedSprite2D = $BulletSprite


func _process(delta):
	if not has_impact_occurred:
		var bullet_movement = bullet_velocity * bullet_speed * delta
		position += bullet_movement
		distance_traveled += bullet_movement.length()
		
		if distance_traveled >= maximum_distance:
			queue_free()


func _on_area_entered(area):
	if area.is_in_group("ZombieHitbox"):
		has_impact_occurred = true
		bullet_sprite.play("BulletImpact")
		area.zombie_take_damage(damage)


func _on_bullet_sprite_animation_finished():
	if has_impact_occurred:
		queue_free()


func bullet_direction(target_position: Vector2):
	bullet_velocity = (target_position - position).normalized()


func set_damage(value: int):
	damage = value
