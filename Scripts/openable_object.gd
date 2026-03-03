extends StaticBody3D

@export_group("Movement Settings")
@export var open_offset: Vector3 = Vector3.ZERO    # Для перемещения (ящики)
@export var open_rotation: Vector3 = Vector3.ZERO  # Для поворота (двери)
@export var duration: float = 0.4

var is_open: bool = false
@onready var parent_mesh = get_parent()

var original_pos: Vector3
var original_rot: Vector3

func _ready():
	original_pos = parent_mesh.position
	original_rot = parent_mesh.rotation

func interact():
	is_open = !is_open
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE)
	
	# Проверка для перемещения
	if open_offset != Vector3.ZERO:
		var target_pos = original_pos + open_offset if is_open else original_pos
		tween.tween_property(parent_mesh, "position", target_pos, duration)
	
	# Проверка для вращения
	if open_rotation != Vector3.ZERO:
		var target_rot_rad = original_rot + Vector3(
			deg_to_rad(open_rotation.x),
			deg_to_rad(open_rotation.y),
			deg_to_rad(open_rotation.z)
		) if is_open else original_rot
		tween.tween_property(parent_mesh, "rotation", target_rot_rad, duration)
