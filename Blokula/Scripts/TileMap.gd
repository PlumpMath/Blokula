extends TileMap
var roomDir = []
var roomMin = []
var roomSize = []
var roomMax = []
var hallMin = []
var hallMax = []
var halls = []
var wallMin = []
var wallMax = []
var occMin = []
var occMax = []
var output = []

#number generator
func get_random_number(num1, num2):
    randomize()
    return int(rand_range(num1, num2 + 1))

#calculates the number of rooms and their cardinal directions: 1 = n	2 = e	3 = s	4 = w
func get_direction():
	var dir = [get_random_number(1, 4)]
	var dirCount = 0
	var roomCount = get_random_number(4, 10)
	
	while (dirCount != roomCount):
		dir.append(new_direction(dir[dirCount]))
		dirCount += 1
	return dir

#corrects directions to prevent too much overlap.
func new_direction(olddir): 
	var newdir = get_random_number(1, 4)

	if (newdir == 1 or newdir == 3) and (olddir == 1 or olddir == 3):
		if newdir != olddir:
			return new_direction(olddir)
		else:
			return newdir
	elif (newdir == 2 or newdir == 4) and (olddir == 2 or olddir == 4):
		if newdir != olddir:
			return new_direction(olddir)
		else:
			return newdir
	else:
		return newdir

#calculates the starting point of each room.
func get_roomMin(roomDir):
	var roomCount = 0
	var roomMin = [Vector2(0, 0)]
	
	while (roomCount != roomDir.size()):
		var dir = roomDir[roomCount]
		if dir == 1:
			roomMin.append(Vector2(roomMin[roomCount].x, (roomMin[roomCount].y - get_random_number(12, 16))))
		if dir == 2:
			roomMin.append(Vector2((roomMin[roomCount].x + get_random_number(12, 16)), roomMin[roomCount].y))
		if dir == 3:
			roomMin.append(Vector2(roomMin[roomCount].x, (roomMin[roomCount].y + get_random_number(12, 16))))
		if dir == 4:
			roomMin.append(Vector2((roomMin[roomCount].x - get_random_number(12, 16)), roomMin[roomCount].y))
		roomCount += 1
	return roomMin

#calculates the size of each room.
func get_roomSize(roomMin):
	var roomCount = 0
	var roomSize = []
	while (roomCount != roomMin.size()):
		roomSize.append(Vector2(get_random_number(6, 10), get_random_number(6, 10)))
		roomCount += 1
	return roomSize

#calculates the ending point of each room.
func get_roomMax(roomMin, roomSize):
	var roomCount = 0
	var roomMax = []
	while (roomCount != roomMin.size()):
		roomMax.append(roomMin[roomCount] + roomSize[roomCount])
		roomCount += 1
	return roomMax

#calculates the starting point of each hall.
func get_hallMin(roomDir, roomMin, roomSize):
	var hallCount = 0
	var hallMin = []
	
	while (hallCount != (roomMin.size() - 1)):
		var dir = roomDir[hallCount]
		if dir == 1:
			hallMin.append(Vector2((roomMin[hallCount].x + 4), roomMin[hallCount].y))
		if dir == 2:
			hallMin.append(Vector2((roomMin[hallCount].x + roomSize[hallCount].x), (roomMin[hallCount].y + 4)))
		if dir == 3:
			hallMin.append(Vector2((roomMin[hallCount].x + 4), (roomMin[hallCount].y + roomSize[hallCount].y)))
		if dir == 4:
			hallMin.append(Vector2(roomMin[hallCount].x, (roomMin[hallCount].y + 4)))
		hallCount += 1
	return hallMin

#calculates the ending point of each hall.
func get_hallMax(roomDir, roomMin, roomSize):
	var hallCount = 0
	var hallMax = []
	
	while (hallCount != (roomMin.size() - 1)):
		var dir = roomDir[hallCount]
		if dir == 1:
			hallMax.append(Vector2((roomMin[(hallCount + 1)].x + 5), (roomMin[(hallCount + 1)].y + roomSize[(hallCount + 1)].y)))
		if dir == 2:
			hallMax.append(Vector2(roomMin[(hallCount + 1)].x, (roomMin[(hallCount + 1)].y + 5)))
		if dir == 3:
			hallMax.append(Vector2((roomMin[(hallCount + 1)].x + 5), roomMin[(hallCount + 1)].y))
		if dir == 4:
			hallMax.append(Vector2((roomMin[(hallCount + 1)].x + roomSize[(hallCount + 1)].x), (roomMin[(hallCount + 1)].y + 5)))
		hallCount += 1
	return hallMax

#Dissects a given room and returns walls and occluders.
func dissect_room(roomMin, roomMax):
	var output = []
	#wall Min/Max
	output.append(Vector2((roomMin.x + 1), roomMin.y))
	output.append(Vector2((roomMax.x - 1), roomMin.y))

	output.append(Vector2((roomMin.x + 1), (roomMin.y - 1)))
	output.append(Vector2(roomMax.x, (roomMin.y - 1)))

	output.append(Vector2(roomMin.x, roomMin.y))
	output.append(Vector2(roomMin.x, roomMax.y))
	
	output.append(Vector2((roomMin.x + 1), roomMax.y))
	output.append(Vector2(roomMax.x, roomMax.y))
	
	output.append(Vector2(roomMax.x, roomMin.y))
	output.append(roomMax)
	
	return output

#Dissects a given hall and returns walls and occluders.
func dissect_hall(hallMin, hallMax, roomDir):
	var output = []
	
	if roomDir == 1 or roomDir == 3:
		output.append(Vector2((hallMin.x - 1), hallMin.y))
		output.append(Vector2((hallMin.x - 1), hallMax.y))
	
		output.append(Vector2((hallMax.x + 1), hallMin.y))
		output.append(Vector2((hallMax.x + 1), hallMax.y))
	
	if roomDir == 2 or roomDir == 4: 
		#wall Min/Max
		output.append(Vector2(hallMin.x, (hallMin.y - 1)))
		output.append(Vector2(hallMax.x, (hallMin.y - 1)))

		output.append(Vector2(hallMin.x, (hallMax.y + 1)))
		output.append(Vector2(hallMax.x, (hallMax.y + 1)))
	
	return output

#draws tiles according to given room parameters.
func draw_tile(Min, Max, Tile):
	var roomCount = 0
	while(roomCount != Max.size()):
		var tileMin = Vector2(Min[roomCount])
		var tileMax = Vector2(Max[roomCount])
		var tileCount = tileMin
		var intCheck = int_check(tileMin, tileMax)
		var tileComplete = false
		while(tileComplete != true):
			set_cellv(tileCount, Tile, false, false, false)
			if tileCount.x == tileMax.x:
				tileCount.y += intCheck.y
				tileCount.x = tileMin.x
			else:
				tileCount.x += intCheck.x
			if tileCount.x == tileMax.x and tileCount.y == tileMax.y:
				set_cellv(tileCount, Tile, false, false, false)
				tileComplete = true
		roomCount += 1

#calculates if int is positive or negative for printer.
func int_check(tileMin, tileMax):
	var ints = Vector2(0, 0)
	if tileMin.x < tileMax.x:
		ints.x = 1
	else:
		ints.x = -1
	if tileMin.y < tileMax.y:
		ints.y = 1
	else:
		ints.y = -1
	return ints

func new_level():
	get_tree().reload_current_scene()

func _ready():
	roomDir = get_direction()
	roomMin = get_roomMin(roomDir)
	roomSize = get_roomSize(roomMin)
	roomMax = get_roomMax(roomMin, roomSize)
	hallMin = get_hallMin(roomDir, roomMin, roomSize)
	hallMax = get_hallMax(roomDir, roomMin, roomSize)
	draw_tile(roomMin, roomMax, 0)
	var roomCount = 0
	while (roomCount != roomDir.size()):
		output = dissect_room(roomMin[roomCount], roomMax[roomCount])
		wallMin.append(output[0])
		wallMax.append(output[1])
		occMin.append(output[2])
		occMax.append(output[3])
		occMin.append(output[4])
		occMax.append(output[5])
		occMin.append(output[6])
		occMax.append(output[7])
		occMin.append(output[8])
		occMax.append(output[9])
		roomCount += 1
	roomCount = 0
	while (roomCount != hallMax.size()):
		output = dissect_hall(hallMin[roomCount], hallMax[roomCount], roomDir[roomCount])
		if roomDir[roomCount] == 1 or roomDir[roomCount] == 3:
			occMin.append(output[0])
			occMax.append(output[1])
			occMin.append(output[2])
			occMax.append(output[3])

		if roomDir[roomCount] == 2 or roomDir[roomCount] == 4:
			wallMin.append(output[0])
			wallMax.append(output[1])
			occMin.append(output[2])
			occMax.append(output[3])

		roomCount += 1
	draw_tile(occMin, occMax, 3)
	draw_tile(wallMin, wallMax, 2)
	draw_tile(hallMin, hallMax, 0)

func _input(event):
	if Input.is_action_pressed("test"):
		new_level()