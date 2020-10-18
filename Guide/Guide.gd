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
func page_clicked(page_num: int) -> void:
	print(page_num)
