extends KinematicBody

const walk_speed = 6
const run_speed = 14
var speed = 6 
export var jump_impulse = 20
export var dash_speed = 100 
export var dash_time = 0.1
export var acceleration = 50 
export var friction = 60 
export var air_friction = 10 
export var gravity = 50
export var mouse_sensitivity = 0.05
export var controller_sensitivity = 125
export var wall_slide_speed = 0.7
export var wall_jump_speed = 20

var velocity = Vector3.ZERO
var is_running = false
var snap_vector = Vector3.DOWN
var do_gravity = true
var can_dash = true
var pre_dash_vel = Vector3.ZERO
var last_jumped 
var same_jump = 0
var timer = Timer.new()
var last_normal = Vector3.ZERO
var current_vecotr = Vector3.ZERO

onready var pivot = $Pivot
onready var spring_arm = $SpringArm

var config = ConfigFile.new()

func _ready():
	spring_arm.set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	config.load("res://settings.cfg")
	mouse_sensitivity = config.get_value("gameplay", "mouse_sens", 0.05)
	controller_sensitivity = config.get_value("gameplay", "joy_sens", 170)

func _physics_process(delta):
	var move_direction = Vector3.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	move_direction = move_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()

	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	
	if InputEventJoypadMotion:
		if config.get_value("gameplay", "invert", false) == false:
			spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x - (deg2rad(-axis_vector.y) * controller_sensitivity), -85, 30)
		else:
			spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x - (deg2rad(axis_vector.y) * controller_sensitivity), -85, 30)
		spring_arm.rotation_degrees.y -= (deg2rad(-axis_vector.x) * controller_sensitivity)

	if move_direction.length() != 0:
		velocity.x = velocity.move_toward(move_direction * speed, acceleration * delta).x
		velocity.z = velocity.move_toward(move_direction * speed, acceleration * delta).z
	else:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(move_direction * speed, air_friction * delta).x
			velocity.y = velocity.move_toward(move_direction * speed, air_friction * delta).y

	if do_gravity:
		velocity.y -= gravity * delta

	if is_on_wall() and !is_on_floor() and move_direction.length() != 0:
		if velocity.y < 0:
			velocity.y *= wall_slide_speed
			speed = 1 
		if Input.is_action_just_pressed("jump") and same_jump <= 5:
			wall_jump()
		
	var camera = spring_arm.get_node("Camera")

	if Input.is_action_pressed("run"):
		speed = lerp(speed, run_speed, 0.05)
		is_running = true
	else: 
		speed = lerp(speed, walk_speed, 0.1)
		is_running = false

	if Input.is_action_just_pressed("jump") and !is_on_floor() and (move_direction.x or move_direction.y != 0) and !is_on_wall():
		if can_dash:
			pre_dash_vel = velocity
			add_child(timer)
			timer.wait_time = dash_time 
			timer.one_shot = true
			timer.start()
			timer.connect("timeout", self, "dash_cleanup")
			can_dash = false
			do_gravity = false
			velocity += move_direction * dash_speed

	if is_on_floor():
		can_dash = true
		same_jump = 0
		last_jumped = 0

	snap_vector = -get_floor_normal() if is_on_floor() else Vector3.DOWN


	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_impulse
		snap_vector = Vector3.ZERO
	if Input.is_action_just_released("jump") and velocity.y > jump_impulse /2.5:
		velocity.y = jump_impulse / 2

	if move_direction == Vector3.ZERO:
		camera.fov = lerp(camera.fov, 70, 0.1)
#		if is_on_floor():
#			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
#		else:
#			velocity.x = velocity.move_toward(move_direction * speed, air_friction * delta).x
#			velocity.y = velocity.move_toward(move_direction * speed, air_friction * delta).y
	else:
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-velocity.x, -velocity.z), 13 * delta)
		if is_running:
			camera.fov = lerp(camera.fov, 90, 0.05)
		else:
			camera.fov = lerp(camera.fov, 70, 0.3)

	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true)



func _unhandled_input(event):
	if event is InputEventMouseMotion:
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x - (event.relative.y * mouse_sensitivity), -85, 30)
		spring_arm.rotation_degrees.y = wrapf(spring_arm.rotation_degrees.y - (event.relative.x * mouse_sensitivity), 0, 360)
	if Input.is_action_just_released("scroll_up"):
		spring_arm.spring_length = clamp(lerp(spring_arm.spring_length, spring_arm.spring_length - 2, 0.08), 1, 6) 
	if Input.is_action_just_released("scroll_down"):
		spring_arm.spring_length = clamp(lerp(spring_arm.spring_length, spring_arm.spring_length + 2, 0.08), 1, 6)

func dash_cleanup():
	velocity = velocity / dash_speed 
	velocity.y = 3.5 
	do_gravity = true

func _process(delta):
	spring_arm.translation = translation
	spring_arm.translation.y = translation.y + 1.2
	if self.translation.y < -10:
		get_parent().get_node("Control").visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true

func wall_jump():
	for index in get_slide_count():	
		var collision = get_slide_collision(index)
		if last_jumped == collision.collider_id and zero_fixing(collision.normal.round()) == last_normal:
			same_jump += 1
		else:
			last_jumped = collision.collider_id
			same_jump = 0
			last_normal = zero_fixing(collision.normal.round())
		velocity = collision.normal.normalized() * wall_jump_speed / clamp(same_jump, 1, 5)
		velocity.y += wall_jump_speed / clamp(same_jump, 1, 5)
				


		can_dash = true

func zero_fixing(normal: Vector3):
	if normal.x == 0 or -0:
		normal.x = 0
	if normal.z == 0 or -0:
		normal.z = 0
	if normal.y == 0 or -0:
		normal.y = 0

	return normal
