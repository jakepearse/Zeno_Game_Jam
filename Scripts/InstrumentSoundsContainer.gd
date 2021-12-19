extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Bass_finished():
	$Bass.play()


func _on_Bells_finished():
	$Bells.play()


func _on_Guitar_finished():
	$Guitar.play()


func _on_HiHat_finished():
	$HiHat.play()


func _on_Kick_finished():
	$Kick.play()


func _on_OpenHat2_finished():
	$OpenHat2.play()


func _on_OpenHat_finished():
	$OpenHat.play()

func _on_Piano_finished():
	$Piano.play()


func _on_RimShot_finished():
	$RimShot.play()


func _on_Sax_finished():
	$Sax.play()


func _on_Shaker_finished():
	$Shaker.play()


func _on_Snare_finished():
	$Snare.play()
