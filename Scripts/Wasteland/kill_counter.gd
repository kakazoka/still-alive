extends Label


var zombies_killed: int = 0


func _ready():
	get_tree().connect("node_added", Callable(self, "_on_node_added"))
	_update_zombie_connections()


func _on_zombie_died():
	zombies_killed += 1
	text = str(zombies_killed)


func _on_node_added(node):
	if node.is_in_group("Zombie"):
		node.connect("zombie_died", Callable(self, "_on_zombie_died"))


func _update_zombie_connections():
	for zombie in get_tree().get_nodes_in_group("Zombie"):
		if not zombie.is_connected("zombie_died", Callable(self, "_on_zombie_died")):
			zombie.connect("zombie_died", Callable(self, "_on_zombie_died"))
