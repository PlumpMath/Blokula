extends RigidBody2D
var direction = Vector2(0, 0)
var path = []
var state = "idle"
onready var paths = get_node("/root/LayTile")
onready var player = get_node("/root/Game/Spawner/Player")

const SPEED = Vector2(6000, 6000)
const IDLE = Vector2(0, 0)
const CLOSE = 1000

func _ready():
	set_process(true)

func _process(delta):
		
	if state == "walk":
		path = paths.get_simple_path(get_global_pos(), player.get_global_pos(), false)
		var distance = path[1] - get_global_pos()
		direction = distance.normalized()
		if path.size() > 2:
			set_linear_velocity(direction * SPEED * delta)
		else:
			set_linear_velocity(IDLE)

func _on_Area2D_body_enter( body ):
	if body.is_in_group("player"):
		state = "walk"

func _on_Area2D_body_exit( body ):
	if body.is_in_group("player"):
		state = "idle"
