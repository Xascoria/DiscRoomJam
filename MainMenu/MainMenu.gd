extends Node2D

func _ready():
	var a = 2 
	a >>= 1
	print(a & 1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
