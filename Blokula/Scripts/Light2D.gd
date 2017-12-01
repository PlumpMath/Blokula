extends Light2D
var light = preload("res://Assets/Sprites/Squalucard/Light.png")
var channelLight = preload("res://Assets/Sprites/Squalucard/ChannelLight.png")

func _ready():
	set_process_input(true)
	set_process(true)
	
func _input(event):
	if Input.is_action_pressed("action"):
		self.set_texture(channelLight)
		self.set_energy(10)
	else:
		self.set_texture(light)
		self.set_energy(1)
	
	if Input.is_action_pressed("north"):
		self.set_rotd(180)
	if Input.is_action_pressed("east"):
		self.set_rotd(90)
	if Input.is_action_pressed("west"):
		self.set_rotd(270)
	if Input.is_action_pressed("south"):
		self.set_rotd(0)
