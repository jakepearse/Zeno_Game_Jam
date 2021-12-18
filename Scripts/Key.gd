extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var s = $Sprite
	$Tween.interpolate_property(
		s,
		'scale', ## property
		Vector2(10, 10), ## from
		Vector2(1, 1), ## to
		0.6, ## dur
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	$Tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
