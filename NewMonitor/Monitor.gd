extends Node2D

onready var actual_game := $Monitor/ViewportContainer/Viewport/Root

func _ready():
	pass # Replace with function body.

signal hook_acquired
func _on_Root_hook_acquired():
	emit_signal("hook_acquired")
