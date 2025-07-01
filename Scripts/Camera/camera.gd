extends Camera2D


var desired_offset: Vector2
var minimum_offset: int = -200
var maximum_offset: int = 200


func _physics_process(_delta):
	desired_offset = (get_global_mouse_position() - position) * 0.5
	desired_offset.x = clamp(desired_offset.x, minimum_offset, maximum_offset)
	desired_offset.y = clamp(desired_offset.y, minimum_offset / 2.0, maximum_offset / 2.0)
	
	global_position = get_tree().get_first_node_in_group("Player").global_position + desired_offset
