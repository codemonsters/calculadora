extends KinematicBody

var gravity = Vector3.DOWN * 10
var baseSpeed = 4
var speed = baseSpeed
var jumpSpeed = 6
var spin = 0.1

var velocity = Vector3()
var airVelocity = Vector3()
var jump = false
var standingOnFloor = false

func getInput():
	velocity.x = 0
	velocity.z = 0
	if Input.is_action_pressed("w"):
		velocity += -transform.basis.z * speed
	if Input.is_action_pressed("s"):
		velocity += transform.basis.z * speed
	if Input.is_action_pressed("a"):
		velocity += -transform.basis.x * speed
	if Input.is_action_pressed("d"):
		velocity += transform.basis.x * speed
	if not standingOnFloor:
		velocity.x = airVelocity.x + velocity.x
		velocity.z = airVelocity.z + velocity.z
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.relative.x > 0:
			rotate_y(-lerp(0, spin, event.relative.x/10))
		elif event.relative.x < 0:
			rotate_y(-lerp(0, spin, event.relative.x/10))

func _physics_process(delta):
	standingOnFloor = is_on_floor()
	velocity += gravity * delta
	getInput()
	velocity = move_and_slide(velocity, Vector3.UP, false, 4, 0.785398, false)
	if jump and standingOnFloor:
		velocity.y = jumpSpeed
		airVelocity = velocity
	if not standingOnFloor:
		speed = baseSpeed * 1.25
	else:
		speed = baseSpeed
	if global_transform.origin.y <= -10:
		global_transform.origin.x = 0
		global_transform.origin.y = 1.25
		global_transform.origin.z = 0


