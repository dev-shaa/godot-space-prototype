extends Node

@export var rigidbody: RigidBody3D

var yaw: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	# rigidbody.rotate_x(roll * delta)
	rigidbody.rotate_y(yaw * delta)
	# rigidbody.rotate_z(pitch * delta)

	yaw = 0

func _input(event):
	if event is InputEventMouseMotion:
		yaw += event.relative.x
