extends Node2D

var current_drag_id = -1

func _ready():
	$Root.score_keeper = self
	$Root2.score_keeper = self
	$Root3.score_keeper = self

func _on_Root_being_dragged(drag_id):
	print("started " + str(drag_id))
	if current_drag_id == -1:
		current_drag_id = drag_id

func _on_Root_stopped_drag(drag_id):
	print("stopped " + str(drag_id))
	if drag_id == current_drag_id:
		current_drag_id = -1
