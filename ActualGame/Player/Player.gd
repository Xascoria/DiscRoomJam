extends KinematicBody2D

func _ready():
	pass # Replace with function body.

export (int) var speed := 0
export (int) var gravity := 10
export (int) var initial_jump_force := 500
export (float) var air_penalty := 1.0
var current_jump_force := 0
onready var chain := $"Grappling/Chain"

func _physics_process(delta):
	var current_velocity := Vector2()
	
	if Input.is_key_pressed(KEY_D):
		current_velocity += Vector2(speed * (air_penalty if not self.is_on_floor() else 1) ,0)
	if Input.is_key_pressed(KEY_A):
		current_velocity += Vector2(-speed * (air_penalty if not self.is_on_floor() else 1) ,0)
	if Input.is_key_pressed(KEY_W) and self.is_on_floor():
		current_jump_force = initial_jump_force
		current_velocity += Vector2(0,-initial_jump_force )
		
	if not self.is_on_floor():
		current_jump_force -= gravity
		current_velocity += Vector2(0, -current_jump_force)
	elif current_jump_force != initial_jump_force:
		current_jump_force = 0

	if is_on_ceiling():
		current_jump_force = 0

	self.move_and_slide(current_velocity, Vector2(0,-1), false, 4, deg2rad(85))


	$Grappling.rotation_degrees += rad2deg( $Grappling.get_angle_to(get_global_mouse_position()) ) + 90
		
