extends Node2D


@export var zombie_scenes: Array[PackedScene]
@export var spawn_radius: float = 1000.0
@export var base_spawn_interval: float = 2.0

var spawn_multiplier: float = 1.0

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_manager: Node = $"../WaveManager"


func _ready():
	await get_tree().process_frame
	_update_spawn_rate()
	spawn_timer.start()


func _on_spawn_timer_timeout():
	if wave_manager and wave_manager.spawning_enabled and player:
		for i in range(spawn_multiplier):
			var spawn_position = _get_spawn_position()
			var zombie_scene = _get_zombie_scene()
			if zombie_scene:
				var zombie = zombie_scene.instantiate()
				zombie.position = spawn_position
				get_parent().add_child(zombie)
				if wave_manager.has_method("_on_zombie_died"):
					zombie.connect("zombie_died", Callable(wave_manager, "_on_zombie_died"))
				if wave_manager.has_method("increment_zombies_remaining"):
					wave_manager.increment_zombies_remaining()
	_update_spawn_rate()


func _update_spawn_rate():
	if wave_manager and wave_manager.wave_timer:
		var wave = wave_manager.wave_number
		spawn_multiplier = 1 + ((wave - 1) / 5)
		if wave_manager.wave_timer.is_stopped() == false and wave_manager.wave_timer.time_left <= 60:
			spawn_timer.wait_time = max(0.5, base_spawn_interval * 0.5)
		else:
			spawn_timer.wait_time = base_spawn_interval


func _get_spawn_position():
	var angle = randf_range(0, TAU)
	return player.position + Vector2(cos(angle), sin(angle)) * spawn_radius


func _get_zombie_scene():
	var wave = wave_manager.wave_number if wave_manager else 1
	if wave <= 3:
		return zombie_scenes[0]
	elif wave >= 4 and wave <= 6:
		return zombie_scenes[randi_range(0, 1)]
	elif wave >= 7 and wave <= 9:
		return zombie_scenes[randi_range(0, 2)]
	else:
		var choices = [0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3]
		return zombie_scenes[choices[randi_range(0, choices.size() - 1)]]
