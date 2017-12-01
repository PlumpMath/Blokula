extends Label

func _ready():
	set_process(true)
	
func _process(delta):
	var points = get_node("/root/Game/Spawner/Player").points
	set_text("Slain: " + str(points))

