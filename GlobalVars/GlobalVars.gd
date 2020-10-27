extends Node

var game_finished_once := false

func _input(event):
	if event is InputEventKey and event.is_pressed() \
	and event.scancode == KEY_R and game_finished_once:
		get_tree().change_scene("res://NewGamePlus/NewGamePlus.tscn")

