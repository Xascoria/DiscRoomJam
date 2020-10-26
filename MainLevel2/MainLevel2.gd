extends Node2D

onready var monitor := $Monitor
onready var cpu := $CPU

func _ready():
	pass # Replace with function body.

var current_inputs := []

func disk_inserted(input_int):
	current_inputs.append(input_int)

func disk_removed(input_int):
	current_inputs.erase(input_int)

func _physics_process(delta):
	monitor.actual_game.controls = current_inputs

func _on_Monitor_hook_acquired():
	pass # Replace with function body.
