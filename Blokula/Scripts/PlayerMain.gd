extends RigidBody2D
var PlayerState = "idle"
var direction = Vector2(0, 0)
var health = 3
var points = 0
var mute = false
onready var attackArea = get_node("Light2D/Area2D")
onready var timer = get_node("Timer")

const SPEED = Vector2(7000, 7000)
const IDLE = Vector2(0, 0)

func _ready():
	set_process(true)
	set_process_input(true)
	
func _input(event):
	
	if Input.is_action_pressed("north"):
		PlayerState = "walk"
		direction.y = -1
	
	elif Input.is_action_pressed("south"):
		PlayerState = "walk"
		direction.y = 1
		
	else:
		direction.y = 0
		
	if Input.is_action_pressed("west"):
		PlayerState = "walk"
		direction.x = -1
	
	elif Input.is_action_pressed("east"):
		PlayerState = "walk"
		direction.x = 1
		
	else:
		direction.x = 0
	
	if Input.is_action_pressed("action"):
		attackArea.set_enable_monitoring(true)
	else:
		attackArea.set_enable_monitoring(false)
	
	if Input.is_action_pressed("mute"):
		if mute == false:
			mute = true
		else:
			mute = false

func _process(delta):
	
	if direction == IDLE:
		PlayerState = "idle"
	
	if PlayerState == "walk":
		set_linear_velocity(direction * SPEED * delta)
	else:
		set_linear_velocity(IDLE * delta)

	if mute == true:
		get_node("/root/Game/SamplePlayer").set_default_volume(-80)
		get_node("/root/Game/StreamPlayer").set_paused(true)
	else:
		get_node("/root/Game/SamplePlayer").set_default_volume(1)
		get_node("/root/Game/StreamPlayer").set_paused(false)

func _on_Area2D_body_enter( body ):
	if body.is_in_group("enemy"):
		points += 1
		get_node("/root/Game/SamplePlayer").play("slaywav")
		body.queue_free()
