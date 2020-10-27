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
	5: $DragAndDropLayer/Disc5,
	6: $DragAndDropLayer/Disc6,
	7: $DragAndDropLayer/Disc7,
	8: $DragAndDropLayer/Disc8,
}

var current_drag_id = -1
onready var drag_and_drop_layer := $DragAndDropLayer

onready var slot_1_check := $CPUCollision/InsideCheck1
onready var slot_2_check := $CPUCollision/InsideCheck2
onready var input_area_1 := $"CPUCollision/InputArea1"
onready var input_area_2 := $"CPUCollision/InputArea2"
var disc_in_slot_1 := -1
var disc_in_slot_2 := -1

func started_drag(drag_id: int) -> void:
	if current_drag_id == -1:
		if drag_id == disc_in_slot_1 or disc_in_slot_1 == -1:
			$CPUCollision/CPUExterior/Slot1.disabled = true
		else:
			$CPUCollision/CPUExterior/Slot1.disabled = false
		if drag_id == disc_in_slot_2 or disc_in_slot_2 == -1:
			$CPUCollision/CPUExterior/Slot2.disabled = true
		else:
			$CPUCollision/CPUExterior/Slot2.disabled = false
		current_drag_id = drag_id

func stopped_drag(drag_id: int) -> void:
	if current_drag_id == drag_id:
		if len(disc_refs[current_drag_id].points_in_collider(slot_1_check)) == 3:
			disc_in_slot_1 = current_drag_id
		elif drag_id == disc_in_slot_1:
			disc_in_slot_1 = -1
		if len(disc_refs[current_drag_id].points_in_collider(slot_2_check)) == 3:
			disc_in_slot_2 = current_drag_id
		elif drag_id == disc_in_slot_2:
			disc_in_slot_2 = -1
		current_drag_id = -1

signal inserted_disk(input_int)
signal removed_disk(input_int)
	
func _on_InputArea1_body_entered(body):
	SfxPlayer.play_keys()
	emit_signal("inserted_disk", body.input_int)
	
func _on_InputArea1_body_exited(body):
	emit_signal("removed_disk", body.input_int)

func _on_InputArea2_body_entered(body):
	SfxPlayer.play_keys()
	emit_signal("inserted_disk", body.input_int)

func _on_InputArea2_body_exited(body):
	emit_signal("removed_disk", body.input_int)

var first_stack_moved := false
var second_stack_moved := false
func move_first_stack() -> void:
	if not first_stack_moved:
		for i in range(1,3+1):
			$DragAndDropLayer/Tween.interpolate_property(
				disc_refs[i], "position", disc_refs[i].position,disc_refs[i].position + Vector2(-650,0), 1
			)
		$DragAndDropLayer/Tween.start()
		first_stack_moved = true

func move_second_stack() -> void:
	if not second_stack_moved:
		for i in range(4,8+1):
			$DragAndDropLayer/Tween.interpolate_property(
				disc_refs[i], "position", disc_refs[i].position,disc_refs[i].position + Vector2(-650,0), 1
			)
		$DragAndDropLayer/Tween.start()
		second_stack_moved = true

###
### Deal with collisions and layers
###


# TODO: Swap visible with z-index logic
#func _physics_process(delta):
#	if current_drag_id != -1:
#		if outer_check_passed:
#			if 1 in disc_refs[current_drag_id].points_in_collider(inner_detect):
#				#TODO: layers
#				interior_colli_enabled = true
#
#		var outer_check_result : Array = disc_refs[current_drag_id].points_in_collider(outer_detect) 
#		outer_check_passed = len(outer_check_result) == 3
#		if len(outer_check_result) == 0 and interior_colli_enabled:
#			interior_colli_enabled = false
#			#TODO: layers

#func set_cpu_in_colli(enable: bool) -> void:
#	for i in $CPUCollision/CPUInterior.get_children():
#		i.disabled = not enable
#	if enable:
#		if disc_in_slot_1 != -1:
#			$CPUCollision/CPUExterior/Slot1.disabled = false
#		if disc_in_slot_2 != -1:
#			$CPUCollision/CPUExterior/Slot2.disabled = false
#	else:
#		$CPUCollision/CPUExterior/Slot1.disabled = true
#		$CPUCollision/CPUExterior/Slot2.disabled = true

###
### Deal with z-indexes and process order
###

#onready var front_cover := $DragAndDropLayer/DiskCoverCPU
#
#func swap_children(child_1: Node, child_2: Node) -> void:
#	var index_1 = child_1.get_index()
#	var index_2 = child_2.get_index()
#	#Making sure index_1 is always smaller
#	if index_1 < index_2:
#		drag_and_drop_layer.move_child(child_1, index_2)
#		drag_and_drop_layer.move_child(child_2, index_1)
#	else:
#		drag_and_drop_layer.move_child(child_2, index_1)
#		drag_and_drop_layer.move_child(child_1, index_2)
#
#func reshuffle_tree() -> void:
#	var children := drag_and_drop_layer.get_children()
#	for i in range(len(children)):
#		children[i].z_index = len(children) - i





