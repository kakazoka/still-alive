extends AnimatedSprite2D


var is_wasteland_prompt_active: bool

@onready var pop_up_timer: Timer = $PopUpSpriteTimer
@onready var visibility_delay_timer: Timer = $VisibilityDelayTimer


func _ready():
	visible = true
	
	is_wasteland_prompt_active = false
	
	play("Idle")


func _on_animation_finished():
	if animation == "Idle" and not is_wasteland_prompt_active:
		visibility_delay_timer.start()


func _on_visibility_delay_timer_timeout():
	if not is_wasteland_prompt_active:
		visible = false
		pop_up_timer.start()


func _on_pop_up_sprite_timer_timeout():
	if not is_wasteland_prompt_active:
		visible = true
		play("Idle")

func set_prompt_active(active: bool):
	is_wasteland_prompt_active = active
	if active:
		visible = false
		pop_up_timer.stop()
		visibility_delay_timer.stop()
	else:
		visible = true
		play("Idle")
