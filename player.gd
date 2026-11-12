extends Node3D

@export var mouse_sensitivity: float = 0.002
@export var max_look_horizontal: float = 20.0
@export var max_look_angle: float = 80.0
@export var smooth_speed: float = 25.0

@onready var head: Node3D = $Head
@onready var cam: Camera3D = $Head/Camera3D
@onready var tableCam: Marker3D = $"../tableCam"

var target_rot_y: float = 0.0
var looking_at_table: bool = false

var default_cam_pos: Vector3
var default_cam_rot: Vector3

func _ready() -> void:
	default_cam_pos = cam.position
	default_cam_rot = cam.rotation

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not looking_at_table:
		target_rot_y -= event.relative.x * mouse_sensitivity
		
		target_rot_y = clamp(
			target_rot_y,
			deg_to_rad(-max_look_horizontal),
			deg_to_rad(max_look_horizontal)
		)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("table cam"):
		looking_at_table = !looking_at_table

	if looking_at_table:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		cam.global_position = lerp(cam.global_position, tableCam.global_position, 5 * delta)
		cam.global_rotation = lerp(cam.global_rotation, tableCam.global_rotation, 5 * delta)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		cam.position = lerp(cam.position, default_cam_pos, 5 * delta)
		cam.rotation = lerp(cam.rotation, default_cam_rot, 5 * delta)
		
		rotation.y = lerp_angle(rotation.y, target_rot_y, smooth_speed * delta)
