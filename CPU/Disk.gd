extends KinematicBody2D
class_name Disk

func _ready():
	pass # Replace with function body.

###
### Drag and drop system
### Ah shit, here we go again
###

var hovering := false
var dragging := false
var holding_m1 := false
#Score keeper keep track of other draggable entities
var score_keeper : Node = null
export var drag_id := 0
#Communicate with parent
signal being_dragged(drag_id)
signal stopped_drag(drag_id)
const offset := Vector2(-96,-96)

func _on_Root_mouse_entered():
	if not holding_m1:
		hovering = true

func _on_Root_mouse_exited():
	hovering = false

func _physics_process(delta):
	holding_m1 = Input.is_mouse_button_pressed(BUTTON_LEFT)
	
	if holding_m1 and hovering:
		if score_keeper.current_drag_id == self.drag_id or score_keeper.current_drag_id == -1:
			if not dragging:
				dragging = true
				emit_signal("being_dragged", drag_id)
			var destination = get_global_mouse_position() - global_position + offset
			move_and_collide(Vector2(destination.x, 0))
			move_and_collide(Vector2(0, destination.y))
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

var disc_data := {
	"index": -1,
	"name": "",
	"jap_char": "",
	"serial": -1,
	"bytes": -1,
	"memory_data": "",
	"key": "",
	"compliment": "",
	"checksum": "",
	"security": "",
}
func constructor(new_data: Dictionary) -> void:
	self.disc_data = new_data
	
	$TextboxOutline/JapSymbol.text = disc_data["jap_char"]
	$TextboxOutline/SerialNumber.text = str(disc_data["serial"])
