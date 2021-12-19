extends Control

var timer

func _ready():
	pass # Replace with function body.
	timer = get_node("Timer")
	timer.set_wait_time(2)
	timer.connect("timeout", self, "_on_Timer_timeout")

func _on_Button_pressed():
	$MenuMusic.set_volume_db(-80)
	$Transition.play()
	timer.start()
	
func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/Level.tscn")
	
func _on_MenuMusic_finished():
	$MenuMusic.play()
