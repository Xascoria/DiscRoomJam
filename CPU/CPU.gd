extends Node2D

###
### Drag and drop
###

func _ready():
	for i in disc_refs.values():
		i.score_keeper = self
		i.connect("being_dragged", self, "started_drag")
		i.connect("stopped_drag", self, "stopped_drag")
		
	self.set_cpu_in_colli(false)
	reshuffle_tree()

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
		if current_drag_id == disc_in_slot_1:
			disc_in_slot_1 = -1
			set_cpu_in_colli(true)
		elif current_drag_id == disc_in_slot_2:
			disc_in_slot_2 = -1
			set_cpu_in_colli(true)

func stopped_drag(drag_id: int) -> void:
	if current_drag_id == drag_id:
		if interior_colli_enabled:
			if 1 in disc_refs[current_drag_id].points_in_collider(slot_1_check):
				disc_in_slot_1 = current_drag_id
			elif 1 in disc_refs[current_drag_id].points_in_collider(slot_2_check):
				disc_in_slot_2 = current_drag_id
		current_drag_id = -1
		
###
### Deal with collisions and layers
###
	
onready var outer_detect := $CPUCollision/OuterCheck
onready var inner_detect := $CPUCollision/InnerCheck
onready var slot_1_check := $CPUCollision/InsideCheck1
onready var slot_2_check := $CPUCollision/InsideCheck2
var outer_check_passed := false
var interior_colli_enabled := false
var disc_in_slot_1 := -1
var disc_in_slot_2 := -1

# TODO: Swap visible with z-index logic
func _physics_process(delta):
	if current_drag_id != -1:
		if outer_check_passed:
			if 1 in disc_refs[current_drag_id].points_in_collider(inner_detect):
				#TODO: layers
				interior_colli_enabled = true
				set_cpu_in_colli(true)
		
		var outer_check_result : Array = disc_refs[current_drag_id].points_in_collider(outer_detect) 
		outer_check_passed = len(outer_check_result) == 3
		if len(outer_check_result) == 0 and interior_colli_enabled:
			interior_colli_enabled = false
			set_cpu_in_colli(false)
			#TODO: layers

func set_cpu_in_colli(enable: bool) -> void:
	for i in $CPUCollision/CPUInterior.get_children():
		i.disabled = not enable
	if enable:
		if disc_in_slot_1 != -1:
			$CPUCollision/CPUExterior/Slot1.disabled = false
		if disc_in_slot_2 != -1:
			$CPUCollision/CPUExterior/Slot2.disabled = false
	else:
		$CPUCollision/CPUExterior/Slot1.disabled = true
		$CPUCollision/CPUExterior/Slot2.disabled = true

###
### Deal with z-indexes and process order
###

onready var front_cover := $DragAndDropLayer/DiskCoverCPU

func swap_children(child_1: Node, child_2: Node) -> void:
	var index_1 = child_1.get_index()
	var index_2 = child_2.get_index()
	#Making sure index_1 is always smaller
	if index_1 < index_2:
		drag_and_drop_layer.move_child(child_1, index_2)
		drag_and_drop_layer.move_child(child_2, index_1)
	else:
		drag_and_drop_layer.move_child(child_2, index_1)
		drag_and_drop_layer.move_child(child_1, index_2)
		
func reshuffle_tree() -> void:
	var children := drag_and_drop_layer.get_children()
	for i in range(len(children)):
		children[i].z_index = len(children) - i
