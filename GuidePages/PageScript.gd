extends Panel

func _ready():
	pass # Replace with function body.

signal page_clicked(page_num)
func _on_page_pressed(page_num: int) -> void:
	emit_signal("page_clicked", page_num)
