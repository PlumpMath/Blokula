extends Node2D
var enemies = []
onready var roomMin = get_node("/root/LayTile/TileMap").roomMin
func load_player():
	var player = load("res://Scenes/Player.tscn")
	var spawnPlayer = player.instance()
	self.add_child(spawnPlayer)
	spawnPlayer.set_pos(Vector2(128, 128))

func get_enemies(roomMin):
	var enemy = load("res://Scenes/Blokula.tscn")
	var enemies = []
	var enemyCount = 0
	while (enemyCount != (roomMin.size() - 1)):
		enemies.append(enemy.instance())
		enemyCount += 1
	return enemies

func _ready():
	load_player()
	enemies = get_enemies(roomMin)
	var count = 1
	while (count != (roomMin.size() - 1)):
		self.add_child(enemies[count])
		enemies[count].set_pos(Vector2(((roomMin[count].x * 64) + 256), ((roomMin[count].y * 64) + 256)))
		count += 1
