extends CollisionShape2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chase = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	
	
func _on_detector_body_entered(body):
	if body.name == "player":
		chase = true
		
		
