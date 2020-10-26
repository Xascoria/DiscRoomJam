extends KinematicBody2D

func _ready():
	$Grappling/Chain/Timer.wait_time = chain_max_time

export (int) var speed := 0
export (int) var gravity := 10
export (int) var initial_jump_force := 500
export (float) var air_penalty := 1.0
export (float) var chain_max_time := 1.0
var current_jump_force := 0

export (int) var chain_pull := 105
var chain_velocity := Vector2()
onready var chain := $"Grappling/Chain"
var controls_given := []
var fake_cursor_pos :=  Vector2()

func _physics_process(delta):
	
#	if Input.is_mouse_button_pressed(BUTTON_LEFT):
	if 1 in controls_given:
		if not chain.hooked and not chain.flying:
			chain.shoot( fake_cursor_pos - chain.global_position )
	else:
		if chain.hooked or chain.flying:
			chain.release()
	
	if chain.hooked:
		chain_velocity = to_local(chain.tip_global).normalized() * chain_pull
	else:
		chain_velocity = Vector2(0,0)
	
	var current_velocity := Vector2()
	
	if 2 in controls_given:
		current_velocity += Vector2(speed * (air_penalty if not self.is_on_floor() else 1) ,0)
	if 3 in controls_given:
		current_velocity += Vector2(-speed * (air_penalty if not self.is_on_floor() else 1) ,0)
	if 4 in controls_given and self.is_on_floor():
		current_jump_force = initial_jump_force
		current_velocity += Vector2(0,-initial_jump_force )
		
	if not self.is_on_floor() and not chain.hooked:
		current_jump_force -= gravity
		current_velocity += Vector2(0, -current_jump_force)
	elif current_jump_force != initial_jump_force:
		current_jump_force = 0

	if is_on_ceiling():
		current_jump_force = 0

	self.move_and_slide(current_velocity + chain_velocity, Vector2(0,-1), false, 4, deg2rad(85))


	$Grappling.rotation_degrees += rad2deg( $Grappling.get_angle_to( fake_cursor_pos ) ) + 90
		
