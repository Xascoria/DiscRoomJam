extends Node2D

###
### Drag and drop
###

func _ready():
	for i in disc_refs.values():
		i.score_keeper = self
		i.connect("being_dragged", self, "started_drag")
		i.connect("stopped_drag", self, "stopped_drag")

onready var disc_refs = {
	1: $DragAndDropLayer/Disc1,
	2: $DragAndDropLayer/Disc2,
	3: $DragAndDropLayer/Disc3,
	4: $DragAndDropLayer/Disc4,
}

var current_drag_id = -1
onready var drag_and_drop_layer := $DragAndDropLayer

func started_drag(drag_id: int) -> void:
	if current_drag_id == -1:
		current_drag_id = drag_id

func stopped_drag(drag_id: int) -> void:
	if current_drag_id == drag_id:
		current_drag_id = -1
