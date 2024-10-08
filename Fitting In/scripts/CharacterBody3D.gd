extends CharacterBody3D
#change player body

@onready var MainCamera = get_node("Camera3D")

const SPEED = 5.0
const JUMP_VELOCITY = 5
var airAction = true
var canClimbWall = true

var cameraRotation = Vector2(0,0)
@export var mouseSens = .001

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Camera3D/SubViewportContainer/SubViewport.size = DisplayServer.window_get_size()

func _input(event):
	if event is InputEventMouseMotion:
		var MouseEvent = event.relative * mouseSens
		cameraLook(MouseEvent)

#camera rotation
func cameraLook (Movement:Vector2):
	cameraRotation += Movement
	cameraRotation.y = clamp(cameraRotation.y, -1.5, 1.5)
	transform.basis = Basis()
	MainCamera.transform.basis = Basis()
	
	rotate_object_local(Vector3(0,1,0), -cameraRotation.x)
	MainCamera.rotate_object_local(Vector3(1,0,0), -cameraRotation.y)

var timerStart = false
func _physics_process(delta):
	$Camera3D/SubViewportContainer/SubViewport/viewModelCamera.global_transform = MainCamera.global_transform
	
	if is_on_floor():
		airAction = true
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
		#doubleJump
		if Input.is_action_just_pressed("jump") && airAction == true:
			velocity.y = JUMP_VELOCITY
			airAction = false
	
		#wallrun/stick
		if is_on_wall_only() && canClimbWall == true:
			#cling to wall while holding jump
			if Input.is_action_pressed("jump"):
				velocity.y = 0
				airAction = true
				if timerStart == false:
					$wallTimer.start(1)
					timerStart = true
			#push off wall when jump is released
			if Input.is_action_just_released("jump"):
				velocity = Vector3(0,5,5)
		#stop energy timer when off wall
		if is_on_wall() != true:
			timerStart = false
			$wallTimer.stop()
		
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		canClimbWall = true
	
	
	
	#movement
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("punch"):
		$Camera3D/SubViewportContainer/SubViewport/viewModelCamera/fpsRig/AnimationPlayer.play("punch")

#timer for wall jumps
func _on_wall_timer_timeout():
	$wallTimer.stop()
	velocity.x = -2
	airAction = false
	canClimbWall = false
	timerStart = false

#HUD Scripts
func _process(_delta):
	#updates the energy bar and air action hud
	if $wallTimer.time_left > 0:
		$HUD/wallEnergy.value = $wallTimer.time_left
	$HUD/airActionIndicator.button_pressed = airAction

#can only collide on certain layer, if collision deletes breakable block node
func _on_area_3d_body_entered(body):
	var block = body.get_parent()
	block.queue_free()
	print("hit")
