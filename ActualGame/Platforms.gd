extends StaticBody2D

# For rectangles only
# Make sure the center Shape is in StaticBody's midpoint

func _ready():
	var extents : Vector2 = get_child(0).shape.extents
	var polygon := Polygon2D.new()
	polygon.color = Color.white
	polygon.polygon = PoolVector2Array(
		[Vector2(0,0), Vector2(extents.x * 2, 0),Vector2(extents.x * 2,extents.y * 2), Vector2(0, extents.y * 2)]
	)
	polygon.position = - extents
	self.add_child(polygon)

