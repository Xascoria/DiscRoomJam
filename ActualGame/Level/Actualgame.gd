extends Node2D

onready var camera := $Player/Camera2D

func _ready():
	camera.limit_left = $Borders/bottom_left.position.x
	camera.limit_right = $Borders/bottom_right.position.x
	camera.limit_bottom = $Borders/bottom_left.position.y

