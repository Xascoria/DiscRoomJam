extends Node2D

func _ready():
	cpu.move_first_stack()

onready var monitor := $Monitor
onready var cpu := $CPU
var current_inputs := []
var start_time := 0


func disk_inserted(input_int):
	if start_time == 0:
		start_time = OS.get_unix_time()
	current_inputs.append(input_int)

func disk_removed(input_int):
	current_inputs.erase(input_int)

var control_enabled := true
func _physics_process(delta):
	monitor.actual_game.controls = current_inputs if control_enabled else []

func _on_Monitor_game_ended():
	var time_now = OS.get_unix_time()
	var elapsed = time_now - start_time
	var minutes = elapsed / 60
	var seconds = elapsed % 60
	$Monitor.time_taken = "%02d:%02d" % [minutes, seconds]
	$Monitor.start_credit()
	
	control_enabled = false

func _on_Monitor_hook_acquired():
	cpu.move_second_stack()
