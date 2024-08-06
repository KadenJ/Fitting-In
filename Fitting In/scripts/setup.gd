extends Node3D
var roomCube = preload("res://cube.tscn")
var breakableCube = preload("res://breakableCube.tscn")
var blockList = []

var blockCoord:Vector3
var missingBlock: int

var roomMade = false

signal newRound


# Called when the node enters the scene tree for the first time.
func _ready():
	newRound.connect(newRoundSetup)
	newRound.emit()
	
	#starts laser timer
	$room/Laser/Timer.start()


func buildRoom():
	#got right count, not right block in blockList
	#builds a 6x6 box as the vault
	var blockPosition = Vector3(0, 0, 0)
	
	#floor
	for x in range(6):
		for z in range(6):
			var block = roomCube.instantiate()
			block.position = blockPosition 
			
			if x > 0 && x < 5:
				if z > 0 && z < 5:
					blockList.append(block)
				else: block.hide()
			else: block.hide()
			
			add_child(block)
			blockPosition.x += 2
		blockPosition.z += 2
		blockPosition.x = 0
	
	blockPosition = Vector3(0,2,0)
	#wall
	for y in range(5):
		for x in range(6):
			var block = roomCube.instantiate()
			block.position = blockPosition
			if x > 0 && x < 5:
				blockList.append(block)
			else: block.hide()
			
			add_child(block)
			blockPosition.x += 2
		blockPosition.y += 2
		blockPosition.x = 0
	for y in range(5):
		blockPosition.y -= 2
		for x in range(6):
			var block = roomCube.instantiate()
			block.position = blockPosition
			if x > 0 && x < 5:
				blockList.append(block)
			else: block.hide()
			
			add_child(block)
			blockPosition.z += 2
		blockPosition.z = 0
		
	blockPosition = Vector3(10,2,10)
	for y in range(5):
		for x in range(6):
			var block = roomCube.instantiate()
			block.position = blockPosition
			if x > 0 && x < 5:
				blockList.append(block)
			else: block.hide()
			
			add_child(block)
			blockPosition.x -= 2
		blockPosition.y += 2
		blockPosition.x = 10
	for y in range(5):
		blockPosition.y -= 2
		for x in range(6):
			var block = roomCube.instantiate()
			block.position = blockPosition
			if x > 0 && x < 5:
				blockList.append(block)
			else: block.hide()
			
			add_child(block)
			blockPosition.z -= 2
		blockPosition.z = 10
		
	#correct count = 96
	print(len(blockList))
	

	missingBlock = 71
	blockCoord = blockList[missingBlock].position

	blockList[missingBlock].position = Vector3(15,15,15)
	#blockList[missingBlock].hide()
	
	roomMade = true

func newRoundSetup():
	#cleans up room, sets room made to false
	for x in len(blockList):
		blockList[x].queue_free()
	buildRoom()

func _on_room_new_hole():
	#when new hole is needed, hole is replaced
	
	#saves previous block data
	var preBlock = missingBlock
	var preBlockCoord = blockCoord
	
	#gets and moves new block
	missingBlock = randi() % len(blockList)
	blockCoord = blockList[missingBlock].position
	blockList[missingBlock].position = Vector3(15,15,15)
	makeBreakableBlock()
	print(missingBlock)
	
	#gives player 3 seconds before putting block back
	await get_tree().create_timer(3).timeout
	blockList[preBlock].position = preBlockCoord

func makeBreakableBlock():
	var block = breakableCube.instantiate()
	block.position = blockCoord
	add_child(block)
