extends CharacterBody2D


@warning_ignore("unused_signal")
signal zombie_died 

@export var speed: int = 150
@export var damage_amount: int = 10
@export var items: Array[PackedScene]
@export var item_drop_chance: float = 0.2
@export var damage_voices: Array[AudioStreamPlayer2D]

var is_hit: bool
var is_dead: bool

@onready var zombie_sprite: AnimatedSprite2D = $ZombieOneSprite
@onready var zombie_hitbox: Area2D = $ZombieOneHitbox
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")


func _ready():
	is_hit = false
	is_dead = false


func _physics_process(_delta):
	if player.is_dead and not is_dead:
		velocity = Vector2.ZERO
		zombie_sprite.play("Idle")
		
	elif not is_dead and not is_hit:
		velocity = Vector2.ZERO
		
		if player:
			velocity = position.direction_to(player.position) * speed
		
		move_and_slide()
		zombie_sprite.play("Run")


func _on_zombie_one_sprite_animation_finished():
	if zombie_sprite.animation == "Hit":
		is_hit = false
		
	elif zombie_sprite.animation == "Death":
		queue_free()
		
		if items.is_empty():
			return
			
		if randf() < item_drop_chance:
			var item = items.pick_random()
			var item_drop = item.instantiate()
			item_drop.position = position
			get_parent().add_child(item_drop)


func zombie_hit():
	is_hit = true
	velocity = Vector2.ZERO
	zombie_sprite.play("Hit")
	zombie_sprite.frame = 0
	
	if damage_voices:
		var random_index = randi_range(0, damage_voices.size() -1)
		damage_voices[random_index].play()


func stop_movement():
	is_dead = true
	emit_signal("zombie_died")
	zombie_hitbox.set_deferred("monitoring", false)
	zombie_hitbox.set_deferred("monitorable", false)
	set_collision_layer(0)
	set_collision_mask(0)
	set_physics_process(false)
	velocity = Vector2.ZERO
