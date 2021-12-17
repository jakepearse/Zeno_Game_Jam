extends RigidBody2D

export var jumpKey = KEY_A #The button that causes this instance to jump
export var jumpImpulse:Vector2 #Jumping "bumps" the char by this vector.
var floorNode:Node #The node of the floor. Value assigned by Level node.
var inAir = true #Tracks whether the player is not on the ground.

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == jumpKey and !inAir: #Compare the event to the jumpKey var
			apply_central_impulse(jumpImpulse)
			inAir = true


func _on_hit(body):
	if body != floorNode:
		print("Game over!") #Replace with game over sequence
	else:
		inAir = false #The character is now on the ground
