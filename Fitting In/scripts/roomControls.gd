extends Node3D

var laser
const laserHighest = 7
const laserLowest = 1
signal newHole
var laserCountDown 

# Called when the node enters the scene tree for the first time.
func _ready():
	laser = $Laser
	laserCountDown = $"../CharacterBody3D/HUD/Label"
var laserUp = true
func _physics_process(delta):
	#checks global position of laser, if passed ground deletes
	if laser != null:
		
		if laser.position.y <= laserLowest:
			#fill previously made hole
			
			#make new hole
			
			#put laser back in position
			laserUp = false
			$Laser.gravity_scale = -.7
			
	
		if laser.position.y >= laserHighest:
			if laserUp == false:
				print("laser deactive")
				laser.gravity_scale = .7
				laser.freeze = true
				#fill previous hole while making new hole...
				newHole.emit()
				
				$Laser/Timer.wait_time = 7
				$Laser/Timer.start()
				laserUp = true
	if $Laser/Timer.time_left != 0:
		setPlayerTimer()

func setPlayerTimer():
	laserCountDown.show()
	laserCountDown.text = str(int($Laser/Timer.time_left))
	

func _on_laser_grid_body_entered(body):
	if body.get_collision_layer() == 2:
		print("player lasered")

func _on_timer_timeout():
	laser.gravity_scale = .7
	$Laser.freeze = false
	laserCountDown.hide()
	print("laser drop")
