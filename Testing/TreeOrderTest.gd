extends Node2D

func _ready():
	#swap_children(6,7)
	pass
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_m1"):
		print("yyeet")

func swap_children(index_1: int, index_2: int) -> void:
	##Making sure index 1 is always lower
	var working_index_1 := index_1
	var working_index_2 := index_2
	if index_2 < index_1:
		working_index_1 = index_2
		working_index_2 = index_1
	var first_child = get_child(working_index_1)
	var second_child = get_child(working_index_2)
	
	move_child(first_child, working_index_2)
	move_child(second_child, working_index_1)
	
