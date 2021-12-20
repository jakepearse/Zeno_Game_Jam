extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property($sprite, "scale", Vector2(5, 5), Vector2(1, 1), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
