extends Area2D


@export var explosion_speed: int = 400
@export var maximum_distance: int = 1000

var explosion_velocity: Vector2 = Vector2.ZERO
var damage: int = 0
var distance_traveled: int = 0
var has_impact_occurred: bool = false

@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite
@onready var explosion_impact_sound: AudioStreamPlayer2D = $ExplosionImpactSound


func _process(delta):
	if not has_impact_occurred:
		var explosion_movement = explosion_velocity * explosion_speed * delta
		position += explosion_movement
		distance_traveled += explosion_movement.length()
		
		if distance_traveled >= maximum_distance:
			queue_free()


func _on_area_entered(area):
	if area.is_in_group("ZombieHitbox"):
		has_impact_occurred = true
		explosion_sprite.play("ExplosionImpact")
		explosion_impact_sound.play()
		area.zombie_take_damage(damage)


func _on_explosion_sprite_animation_finished():
	if has_impact_occurred:
		queue_free()


func explosion_direction(target_position: Vector2):
	explosion_velocity = (target_position - position).normalized()


func set_damage(value: int):
	damage = value
