extends Node2D

onready var monitor := $Monitor
onready var cpu := $CPU

func _ready():
	$Tutorial/First.visible = false
	$Tutorial/Second.visible = false
	$Tutorial/Third.visible = false

var current_inputs := []
var start_time := 0

func disk_inserted(input_int):
	if $FakeMonitor:
		$FakeMonitor.queue_free()
		start_time = OS.get_unix_time()
	current_inputs.append(input_int)

func disk_removed(input_int):
	current_inputs.erase(input_int)

var control_enabled := true
func _physics_process(delta):
	monitor.actual_game.controls = current_inputs if control_enabled else []
	
func _on_Monitor_hook_acquired():
	_on_EventTimer_timeout()
	$CPU.move_second_stack()
	
func _on_Monitor_game_ended():
	var time_now = OS.get_unix_time()
	var elapsed = time_now - start_time
	var minutes = elapsed / 60
	var seconds = elapsed % 60
	$Monitor.time_taken = "%02d:%02d" % [minutes, seconds]
	$Monitor.start_credit()
	
	control_enabled = false

var num_key_pressed := 0
func _input(event):
	if event is InputEventKey and event.is_pressed():
		num_key_pressed += 1
		if num_key_pressed == 5:
			camera_zoom_out()
			event_ptr = 1
			event_timer.start()
		
func camera_zoom_out() -> void:
	$Camera2D/Tween.interpolate_property($Camera2D, "position", $Camera2D.position, Vector2(0,0), $Camera2D/KillTimer.wait_time)
	$Camera2D/Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1,1), $Camera2D/KillTimer.wait_time)
	$Camera2D/KillTimer.start()
	$Camera2D/Tween.start()

func _on_KillTimer_timeout():
	$Camera2D.queue_free()
	
var event_ptr := 0
onready var event_timer := $Tutorial/EventTimer
func _on_EventTimer_timeout():
	match(event_ptr):
		1:
			$Tutorial/First.visible = true
			event_ptr = 2
			
			event_timer.wait_time = 5
			event_timer.start()
		2:
			$Tutorial/First.visible = false
			$Tutorial/Second.visible = true
			$CPU.move_first_stack()
			event_ptr = 3
			
			event_timer.wait_time = 3
			event_timer.start()
		3:
			$Tutorial/Second.visible = false
			event_ptr = 4
		4:
			$Tutorial/Third.visible = true
			event_ptr = 5
			
			event_timer.wait_time = 4
			event_timer.start()
		5:
			$Tutorial/Third.visible = false
			event_ptr = 6
