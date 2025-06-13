extends RigidBody3D

@export var camera: Node3D
@export_range(0, 1) var sensitivity: float = 0.5
@export var roll_speed: float = 1
@export var push_raycast: RayCast3D
@export var push_force: float = 1
@export var joint: Joint3D

var pitch: float = 0
var roll: float = 0
var yaw: float = 0
var should_push: bool = false

var close_handle: Node3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _physics_process(delta):
	var forward := camera.global_basis * Vector3.FORWARD
	var right := camera.global_basis * Vector3.RIGHT
	var up := camera.global_basis * Vector3.UP

	roll = Input.get_axis("roll_left", "roll_right")

	camera.rotate(forward, roll * roll_speed * delta)
	camera.rotate(right, -pitch * sensitivity * delta)
	camera.rotate(up, yaw * sensitivity * delta)

	if should_push:
		if can_push():
			apply_central_impulse(forward * push_force)

		should_push = false

	yaw = 0
	roll = 0
	pitch = 0

func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x
		pitch += event.relative.y
		pass
	elif event.is_action_pressed("push"):
		should_push = true
	elif event.is_action_pressed("grab"):
		grab(close_handle)
	elif event.is_action_released("grab"):
		grab(null)
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_area_3d_body_entered(body: Node3D):
	if close_handle == null:
		close_handle = body
	pass

func _on_area_3d_body_exited(body: Node3D):
	if body == close_handle:
		close_handle = body
	pass

func can_push() -> bool:
	return true
	return push_raycast.is_colliding()

func grab(handle: Node3D) -> void:
	if handle:
		joint.node_a = self.get_path()
		joint.node_b = handle.get_path()
		print("Grabbed handle")
	else:
		joint.node_a = NodePath()
		joint.node_b = NodePath()
		print("Released handle")
