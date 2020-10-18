extends Node2D

onready var monitor_text := $Monitor/MonitorInner/MonitorText
onready var line_input := $"Monitor/MonitorInner/LineInput"

func _ready():
	line_input.grab_focus()
	
###
### Deal with typing text
###

func grab_input_focus():
	line_input.grab_focus()
	
func release_input_focus():
	line_input.release_focus()

var allow_input := true
signal typed_input(new_text)

func _on_LineInput_gui_input(event):
	#Move the caret to the back
	line_input.caret_position = len(line_input.text)
	
func _on_LineInput_text_entered(new_text):
	if allow_input and len(new_text) != 0:
		user_input_line(">" + new_text)
		emit_signal("typed_input", new_text)
		line_input.text = ""
	
###
### Deal with displaying the text
###

const line_count := 23
var current_line := 1

func user_input_line(new_line: String) -> void:
	if len(new_line) == 0:
		return 
	
	if current_line <= line_count:
		monitor_text.text += new_line + "\n"
		current_line += 1 
	else:
		var index := 0
		while monitor_text.text[index] != "\n":
			index += 1
		monitor_text.text = monitor_text.text.substr(index+1)
		monitor_text.text += new_line + "\n"
		
#No new line included
#Put a new line at the end for a nl
func raw_input_line(new_line: String) -> void:
	monitor_text.text += new_line
	if new_line[len(new_line)-1] == "\n":
		current_line += 1
		if current_line > line_count:
			var index := 0
			while monitor_text.text[index] != "\n":
				index += 1
			monitor_text.text = monitor_text.text.substr(index+1)

#func _input(event):
#	if event is InputEventKey and event.is_pressed():
#		pass
