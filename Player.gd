extends CharacterBody3D


enum {GROUND = 1, AIR, CLIMB}
@export var default_speed = 5.0
var jump_velocity = 4.5
@export var sprint_speed = 8.0
var speed = default_speed
var climb_speed = 2.0
var climb_stop_speed = 0
var normal_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_enabled = true
var player = "res://Player.tscn"


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = normal_gravity


@onready var CameraBase = $CameraBase


func _ready():
	pass



func _input(event):
	if event is InputEventMouseMotion:
		CameraBase.rotation.x -= deg_to_rad(event.relative.y * 1) 
		CameraBase.rotation.x = clamp(CameraBase.rotation.x, deg_to_rad(-90), deg_to_rad(30))
		rotation.y -= deg_to_rad(event.relative.x * 1)
		
		


func damage():
	pass



func _physics_process(delta):
	
		#Gravity 
	if not is_on_floor():
		velocity.y -= gravity * delta

		
		# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_foward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	

	#Sprint
	if Input.is_action_pressed("move_sprint"):
		speed = sprint_speed
	else:
		speed = default_speed
		
	
	#climbing
	if $wall_raycasts/wall_check.is_colliding() and not is_on_floor():
		
		gravity_enabled = false
		velocity.y = 0
		print("wallColide")
		
		if Input.is_action_pressed("move_foward"):
			
			velocity.x = direction.x * climb_speed
			velocity.z = direction.z * climb_speed
			velocity.y = climb_speed
			
		
		if Input.is_action_pressed("move_backward"):
			velocity.x = direction.y * climb_speed
			velocity.z = direction.y * climb_speed
			velocity.y -= climb_speed
		
		if Input.is_action_just_pressed("jump"):
			velocity.y += jump_velocity
			
			
	else:
		gravity_enabled = true
		

		
	
		

		
	move_and_slide()


		
	

		

 
