extends KinematicBody

export var speed = 10
export var h_acceliration = 6
export var air_acceliration = 1
export var normal_acceliration = 6
export var mouse_sensitivity = 0.3
export var gravity  = 20 
export var jump = 10
export var run_speed = 2

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var graviry_vec = Vector3()
var full_contact = false
var run = false

onready var head = $head
onready var ground_check = $GroundCheck
onready var aimcast = $head/Camera/AimCast
onready var gun = $head/hand/uziLongSilencer
onready var muzzle = gun.get_node("Muzzle")
onready var bullet = preload("res://scenes/9mm_Bullet.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89),deg2rad(89))

func _physics_process(delta):	
	if Input.is_action_just_pressed("action_fire") :
		if aimcast.is_colliding():
			var b = bullet.instance()
			muzzle.add_child(b)
			b.look_at(aimcast.get_collision_point(),Vector3.UP)
			b.shoot = true
		else :
			var b = bullet.instance()
			b.rotate_x(deg2rad(180))
			muzzle.add_child(b)
			b.shoot = true
	
	direction = Vector3()
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
		
	if Input.is_action_pressed("move_run"):
		run = true
	else :
		run = false
	
	if not is_on_floor(): 
		graviry_vec += Vector3.DOWN * gravity * delta
		h_acceliration = air_acceliration
	elif  is_on_floor() and full_contact: 
		graviry_vec = -get_floor_normal() * gravity
		h_acceliration = normal_acceliration
	else :
		graviry_vec = -get_floor_normal()
		h_acceliration = normal_acceliration

	if Input.is_action_just_pressed("move_jump") and (is_on_floor() and ground_check.is_colliding()):
		graviry_vec = Vector3.UP * jump

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	elif Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
	direction = direction.normalized()
	if run :
		h_velocity = h_velocity.linear_interpolate(direction * speed * run_speed,h_acceliration * delta)
	else : 
		h_velocity = h_velocity.linear_interpolate(direction * speed,h_acceliration * delta)
	movement.z = h_velocity.z + graviry_vec.z
	movement.x = h_velocity.x + graviry_vec.x
	movement.y = graviry_vec.y
	
	move_and_slide(movement,Vector3.UP)
	
