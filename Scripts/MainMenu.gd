extends Control

func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Level.tscn")


func _on_MenuMusic_finished():
	$MenuMusic.play()
