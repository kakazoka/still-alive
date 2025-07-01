extends CanvasLayer


@warning_ignore("unused_signal")
signal transition_finished

@onready var transition_screen = $TransitionScreen
@onready var transition_screen_animation = $TransitionScreenAnimation


func _ready():
	transition_screen.visible = false
	transition_screen_animation.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(animation_name):
	if animation_name == "fade_in":
		transition_finished.emit()
		transition_screen_animation.play("fade_out")
	elif animation_name == "fade_out":
		transition_screen.visible = false

func transition():
	transition_screen.visible = true
	transition_screen_animation.play("fade_in")
