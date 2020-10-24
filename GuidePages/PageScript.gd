extends Panel

func _ready():
	print("sure".substr(3,4))

export var page_num := -1
signal page_clicked(page_num)

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("page_clicked", page_num)
