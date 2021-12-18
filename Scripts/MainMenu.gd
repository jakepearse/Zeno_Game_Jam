extends Control

func _ready():
	$CanvasLayer2/Transition.In(1.5)

func _on_Button_pressed():
	$CanvasLayer2/Transition.Out(2.0)
	

func _on_MenuMusic_finished():
	$MenuMusic.play()


func _on_Transition_scene_changed():
	print('c')
	get_tree().change_scene("res://Scenes/Level.tscn")
