extends KinematicBody2D

export var moveVector:Vector2 #The vector over which the obstacle will move

func _ready():
	pass # Replace with function body.


func _process(delta):
	move_and_collide(moveVector * delta) #Move the object
#	if position.x < 0: #If this object moves offscreen
#		queue_free() #PERISH
