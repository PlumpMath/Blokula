extends AcceptDialog

func _ready():
	popup()
	get_tree().set_pause(true)


func _on_AcceptDialog_confirmed():
	get_node("/root/Game/Spawner/Player").show()
	get_node("/root/Game/Blackdrop").hide()
	get_tree().set_pause(false)
	
