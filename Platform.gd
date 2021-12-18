extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	move_and_collide(Vector2(-130,0) * delta) #Move the object
	if position.x < 0: #If this object moves offscreen
		queue_free() #PERISH
