extends Node3D

var laser
const laserHighest = 7
const laserLowest = 1
var laserCountDown 

@export var laserCount = 15
var grid

signal newHole

func _ready():
	laser = $Laser
	laserCountDown = $"../CharacterBody3D/HUD/Label"
	grid = $Laser/laserGrid/grid

var laserUp = true
func _physics_process(delta):
	#checks global position of laser, if passed lowest pos goes back up
	if laser != null:
		if laser.position.y <= laserLowest:
			#put laser back in position
			laserUp = false
			$Laser.gravity_scale = -.7
		
		if laser.position.y >= laserHighest:
			if laserUp == false:
				for child in grid.get_child_count(): #deactivates active lasers once on top
					grid.get_child(child).hide()
				print("laser deactive")
				laser.gravity_scale = .7
				laser.freeze = true
				
				#fill previous hole while making new hole add to laser count
				newHole.emit()
				laserControl()
				
				#restarts laser timer
				$Laser/Timer.wait_time = 7
				$Laser/Timer.start()
				laserUp = true
	if $Laser/Timer.time_left != 0:
		setPlayerTimer()

#shows countdown to laser drop
func setPlayerTimer():
	laserCountDown.show()
	laserCountDown.text = str(int($Laser/Timer.time_left))


#countdown before laser drops
func _on_timer_timeout():
	laser.gravity_scale = .7
	$Laser.freeze = false
	laserCountDown.hide()
	print("laser drop")

#add and randomize lasers
func laserControl():
	#activates amount of lasers in laserCount, add more lasers ass game progresses
	for x in laserCount:
		var laser = randi_range(0, grid.get_child_count()-1)
		if grid.get_child(laser).visible == false:
			grid.get_child(laser).show()
		else: while grid.get_child(laser).visible == true:
			laser = randi_range(0, grid.get_child_count()-1)
			if grid.get_child(laser).visible == false:
				grid.get_child(laser).show()
				break
	
	#check if all lasers are active (delete code)
	var lasersOn = 0
	for count in grid.get_child_count():
		if grid.get_child(count).visible == true:
			lasersOn +=1
	print("activeCount", lasersOn)
