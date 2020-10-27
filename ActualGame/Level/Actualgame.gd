extends Node2D

onready var camera := $Player/Camera2D
signal hook_acquired
signal game_ended

func _ready():
	camera.limit_left = $Borders/bottom_left.position.x
	camera.limit_right = $Borders/bottom_right.position.x
	camera.limit_bottom = $Borders/bottom_left.position.y
	$Player.get_node("Grappling").visible = false

var camera_center := Vector2() 
func _process(_delta):
	camera_center = camera.get_camera_screen_center()
	$ScreenBorder.position = camera_center 

func _on_Hook_body_entered(body):
	$Player.get_node("Grappling").visible = true
	emit_signal("hook_acquired")
	$Hook.queue_free()

func _on_End_body_entered(body):
	emit_signal("game_ended")
	$End.queue_free()
	
var controls := []
onready var cursor := $ScreenBorder/Cursor
	
func _physics_process(delta):
	#get_controls_from_keys()
	$Player.controls_given = controls
	if 5 in controls:
		$ScreenBorder/Cursor.move_and_collide(Vector2(0,-4))
	if 6 in controls:
		$ScreenBorder/Cursor.move_and_collide(Vector2(0,4))
	if 7 in controls:
		$ScreenBorder/Cursor.move_and_collide(Vector2(-4,0))
	if 8 in controls:
		$ScreenBorder/Cursor.move_and_collide(Vector2(4,0))
	$Player.fake_cursor_pos = $ScreenBorder/Cursor.global_position

func get_controls_from_keys():
	controls = []
	if Input.is_key_pressed(KEY_E):
		controls.append(1)
	if Input.is_key_pressed(KEY_D):
		controls.append(2)
	if Input.is_key_pressed(KEY_A):
		controls.append(3)
	if Input.is_key_pressed(KEY_W):
		controls.append(4)
	if Input.is_key_pressed(KEY_UP):
		controls.append(5)
	if Input.is_key_pressed(KEY_DOWN):
		controls.append(6)
	if Input.is_key_pressed(KEY_LEFT):
		controls.append(7)
	if Input.is_key_pressed(KEY_RIGHT):
		controls.append(8)
