extends Control

func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	print('pressed')
	get_tree().change_scene("res://Scenes/Level.tscn")
