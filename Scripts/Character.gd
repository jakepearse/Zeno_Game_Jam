extends RigidBody2D

var jumpKey = KEY_A #The button that causes this instance to jump
var floorNode:Node
export var jumpImpulse:Vector2 #Jumping "bumps" the char by this vector.
var inAir = true #Tracks whether the player is not on the ground.

func _ready():
	pass

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == jumpKey and !inAir: #Character has jumped
			$AnimatedSprite.play("Jump")
			apply_central_impulse(jumpImpulse)
			inAir = true


func _on_hit(body):
	if body != floorNode: #Hit an enemy
		self.mode =RigidBody2D.MODE_RIGID #Statement does not work
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://UI/GameOver.tscn")
	else: #Hit the floor
		$AnimatedSprite.play("Land")
		inAir = false 	 #The character is now on the ground
		

func _set_jump_key(scancode):
	jumpKey = scancode
func _set_label(s):
	$Label.text = s


func _on_anim_finished():
	if $AnimatedSprite.animation == "Land":
		$AnimatedSprite.play("Walk")
