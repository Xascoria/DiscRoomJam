extends Panel

onready var pages_refs = {
	0: $GuideTopPoint/Cover,
	1: $"GuideTopPoint/Page 1",
	2: $"GuideTopPoint/Page 2",
}
onready var guide_top_point := $GuideTopPoint

func _ready():
	#Shrink everything at the beginning
	for i in range( len(pages_refs) ):
		if i != 0:
			pages_refs[i].rect_scale.x = 0
		
	#Connect it to the pages flipping logic
	for i in guide_top_point.get_children():
		i.connect("page_clicked", self, "page_clicked")

var flipping := false
const first_page := 0

func page_clicked(page_num: int) -> void:
	var page_flipper = $GuideTopPoint/PageFlipper
	if page_num == first_page + 1:
		page_flipper.interpolate_property(pages_refs[page_num], "rect_scale:x", 
		pages_refs[page_num].rect_scale.x, 0, 0.25)
		page_flipper.interpolate_property(pages_refs[page_num-1], "rect_scale:x", 
		pages_refs[page_num - 1].rect_scale.x, 1, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.25)
		page_flipper.start()
		print(page_num - 1)
	else:
		if page_num % 2 == 0:
			pages_refs[page_num + 2].rect_scale.x = 1
			page_flipper.interpolate_property(pages_refs[page_num], "rect_scale:x", 
			pages_refs[page_num].rect_scale.x, 0, 0.25)
			page_flipper.interpolate_property(pages_refs[page_num+1], "rect_scale:x", 
			pages_refs[page_num + 1].rect_scale.x, 1, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.25)
			page_flipper.start()
		else:
			pass
	
func _physics_process(delta):
	pass
