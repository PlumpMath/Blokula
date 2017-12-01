extends AnimationPlayer

func _ready():
	set_process(true)

func _process(delta):
	var PlayerState = get_node("../..").PlayerState
	
	if PlayerState != get_current_animation():
		set_current_animation(PlayerState)