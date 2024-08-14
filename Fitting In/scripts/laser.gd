extends RayCast3D

@onready var beam_mesh = $beamMesh
@onready var beamcollider = $Area3D/CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cast_point
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
		beam_mesh.mesh.height = cast_point.y 
		beam_mesh.position.y = cast_point.y/2
		
	$Area3D/CollisionShape3D.disabled = !$".".visible

#detects if player is hit by laser
func _on_area_3d_body_entered(body):
	if body.get_collision_layer() == 2:
		#send signal to lose health
		print("player lasered")
