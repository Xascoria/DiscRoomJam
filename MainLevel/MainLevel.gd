extends Node2D

onready var transition_tween := $TransitionTween
onready var monitor := $Computer

func _ready():
	pass 

#0 for computer, 1 for cpu, 2 for guide
var current_pos := 0
const target_pos = {
	0: Vector2(),
	1: Vector2(-1280,0),
	2: Vector2(0,-720),
}
var in_transition := false

func _input(event):
	if event is InputEventKey and event.is_pressed() and not in_transition:
		var previous_pos := current_pos
		match(event.scancode):
			KEY_UP:
				if current_pos == 2:
					current_pos = 0
			KEY_DOWN:
				if current_pos == 0 or current_pos == 1:
					current_pos = 2
			KEY_LEFT:
				if current_pos == 1:
					current_pos = 0
			KEY_RIGHT:
				if current_pos == 0 or current_pos == 2:
					current_pos = 1
		if previous_pos != current_pos:
			in_transition = true
			transition_to(target_pos[current_pos])
			
			if current_pos != 0:
				monitor.release_input_focus()
			else:
				monitor.grab_input_focus()
				

func transition_to(target_coord: Vector2) -> void:
	transition_tween.interpolate_property(self, "position", position, target_coord, 
	1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	transition_tween.start()

func _on_TransitionTween_tween_all_completed():
	in_transition = false
