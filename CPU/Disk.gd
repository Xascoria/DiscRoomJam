extends KinematicBody2D
class_name Disk

func _ready():
	$Appearance/TextboxOutline/SerialNumber.text = str(input_int)

###
### Drag and drop system
### Ah shit, here we go again
###

var hovering := false
var dragging := false
var allow_fresh_drag := false
var holding_m1 := false
#Score keeper keep track of other draggable entities
var score_keeper : Node = null
export var drag_id := 0
#Communicate with parent
signal being_dragged(drag_id)
signal stopped_drag(drag_id)
const offset := Vector2(-96,-96)

func _on_Root_mouse_entered():
	hovering = true

func _on_Root_mouse_exited():
	hovering = false
	allow_fresh_drag = false

func _process(delta):
	holding_m1 = Input.is_mouse_button_pressed(BUTTON_LEFT)
	
	allow_fresh_drag = (not holding_m1 or allow_fresh_drag) and hovering

func _physics_process(delta):
	if holding_m1 and allow_fresh_drag:
		if score_keeper.current_drag_id == self.drag_id or score_keeper.current_drag_id == -1:
			print(score_keeper.current_drag_id)
			if not dragging:
				dragging = true
				emit_signal("being_dragged", drag_id)
			var destination = get_global_mouse_position() - global_position + offset
#			move_and_collide(Vector2(destination.x, 0))
#			move_and_collide(Vector2(0, destination.y))
			move_and_slide(destination * 60)
			#set_global_position( get_global_mouse_position() + offset )
	else:
		if dragging:
			emit_signal("stopped_drag", drag_id)
			dragging = false

func points_in_collider(collider: Area2D) -> Array:
	var output = []
	var point_1 = $DiskPoints/Point1
	var point_2 = $DiskPoints/Point2
	var point_3 = $DiskPoints/Point3
	
	if collider in point_1.get_overlapping_areas():
		output.append(1)
	if collider in point_2.get_overlapping_areas():
		output.append(2)
	if collider in point_3.get_overlapping_areas():
		output.append(3)
		
	return output

###
### Rest of the logic
###

export (int) var input_int := -1

func constructor():
	pass
