extends CharacterBody3D

@export var speed : int = 5
@export var sensitivity : float = 0.005
@export var jump_velocity : int = 2

@onready var camera = $Camera3D
@onready var ray = $Camera3D/RayCast3D

#Гравитация Godot по умолчанию
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * sensitivity
		
		camera.rotation.x -= event.relative.y * sensitivity
		
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
		camera.rotation.z = 0
		camera.rotation.y = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	move_and_slide()

func _input(event):
	if event.is_action_pressed("interact"):
		if ray.is_colliding():
			var obj = ray.get_collider()
			if obj.has_method("interact"):
				obj.interact()
