extends Node2D

onready var actual_game := $Monitor/ViewportContainer/Viewport/Root

func _ready():
	$Monitor/ViewportContainer/Credits.visible = true
	$Monitor/ViewportContainer/Credits.modulate.a = 0

signal hook_acquired
signal game_ended
func _on_Root_hook_acquired():
	emit_signal("hook_acquired")

var time_taken := "" 

func _on_Root_game_ended():
	emit_signal("game_ended")

var credit_ptr := 0
onready var credit_timer := $Monitor/ViewportContainer/Credits/Timer
onready var credit_tween := $Monitor/ViewportContainer/Credits/Tween
func start_credit():
	match(credit_ptr):
		0:
			$"Monitor/ViewportContainer/Credits/1".text = "Your Time: " + time_taken
			for i in $Monitor/ViewportContainer/Credits.get_children():
				if not (i is Timer or i is Tween):
					i.visible = false
			$"Monitor/ViewportContainer/Credits/1".visible = true
			credit_ptr = 1
			
			credit_tween.interpolate_property($Monitor/ViewportContainer/Credits, "modulate:a", 0, 1, 2)
			credit_tween.start()
			
			credit_timer.wait_time = 5
			credit_timer.start()
		1:
			$"Monitor/ViewportContainer/Credits/2".visible = true
			credit_ptr = 2
			
			credit_timer.wait_time = 5
			credit_timer.start()
		2:
			$"Monitor/ViewportContainer/Credits/1".visible = false
			$"Monitor/ViewportContainer/Credits/2".visible = false
			$"Monitor/ViewportContainer/Credits/3".visible = true
			credit_ptr = 3
			
			credit_timer.wait_time = 6
			credit_timer.start()
		3:
			$"Monitor/ViewportContainer/Credits/3".visible = false
			$"Monitor/ViewportContainer/Credits/4".visible = true
			credit_ptr = 4
			
			credit_timer.wait_time = 3
			credit_timer.start()
		4:
			$"Monitor/ViewportContainer/Credits/5".visible = true
			credit_ptr = 5
			
			credit_timer.wait_time = 5
			credit_timer.start()
		5:
			$"Monitor/ViewportContainer/Credits/4".visible = false
			$"Monitor/ViewportContainer/Credits/5".visible = false
			$"Monitor/ViewportContainer/Credits/6".visible = true
			credit_ptr = 6
			GlobalVars.game_finished_once = true


func _on_Timer_timeout():
	start_credit()
