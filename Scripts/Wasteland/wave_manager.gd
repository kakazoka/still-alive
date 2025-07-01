extends Node2D


var zombies_remaining: int = 0
var wave_number: int = 0
var wave_duration: float = 70.0
var pause_duration: float = 05.0
var total_time_survived: float = 0.0
var wave_active: bool
var spawning_enabled: bool
var is_pause_started: bool

@onready var wave_timer: Timer = $WaveTimer
@onready var pause_timer: Timer = $PauseTimer
@onready var wave_counter_label: Label = $"../WastelandInterface/WaveCount/WaveCounter"
@onready var survival_timer_label: Label = $"../WastelandInterface/SurvivalTime/SurvivalTimer"
@onready var pause_warning_label: Label = $"../WastelandInterface/PauseTime/PauseWarning"
@onready var pause_timer_label: Label = $"../WastelandInterface/PauseTime/PauseTimer"
@onready var player = get_tree().get_first_node_in_group("Player")


func _ready():
	wave_active = false
	spawning_enabled = false
	is_pause_started = false
	survival_timer_label.show()
	pause_timer_label.hide()
	wave_counter_label.show()
	pause_warning_label.hide()
	_start_next_wave()


func _process(delta):
	if player.is_dead:
		wave_active = false
		spawning_enabled = false
		wave_timer.stop()
		pause_timer.stop()
		return
	
	if not is_pause_started and not player.is_dead:
		total_time_survived += delta
		survival_timer_label.text = _format_time(total_time_survived)
	
	if is_pause_started and not pause_timer.is_stopped():
		pause_timer_label.text = _format_time(pause_timer.time_left)


func _on_wave_timer_timeout():
	if not is_pause_started:
		wave_active = false
		spawning_enabled = false
		wave_timer.stop()
		
		if zombies_remaining <= 0:
			_start_pause_timer()


func _on_zombie_died():
	if is_pause_started:
		return
		
	if zombies_remaining > 0:
		zombies_remaining -= 1
		
	if zombies_remaining <= 0:
		wave_timer.stop()
		_start_pause_timer()


func _on_pause_timer_timeout():
	if is_pause_started:
		_start_next_wave()


func _start_next_wave():
	wave_number += 1
	wave_counter_label.text = "Wave " + str(wave_number)
	wave_active = true
	spawning_enabled = true
	is_pause_started = false
	survival_timer_label.show()
	pause_timer_label.hide()
	wave_counter_label.show()
	pause_warning_label.hide()
	wave_timer.start(wave_duration)
	zombies_remaining = 0


func _start_pause_timer():
	if is_pause_started:
		return
	
	is_pause_started = true
	wave_active = false
	spawning_enabled = false
	survival_timer_label.hide()
	pause_timer_label.show()
	wave_counter_label.hide()
	pause_warning_label.show()
	pause_timer.start(pause_duration)


func _format_time(time_seconds: float) -> String:
	var minutes = int(time_seconds) / 60
	var seconds = int(time_seconds) % 60
	return "%02d:%02d" % [minutes, seconds]


func increment_zombies_remaining():
	zombies_remaining += 1
