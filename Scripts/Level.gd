extends Node2D


onready var Character = preload("res://Scenes/Character.tscn")
onready var Obstacle = preload("res://Scenes/Obstacle.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var c = Character.instance()
	c.floorNode = $Floor
	c.position = Vector2(32,100)
	c._set_jump_key(65)
	add_child(c)


func _on_ObstacleTimer_timeout():
	var o = Obstacle.instance()
	o.position = Vector2(900,500) #? idk
	add_child(o)
	pass # Replace with function body.


func _on_PlayerTimer_timeout():
	var c = Character.instance()
	c.floorNode = $Floor
	c.position = Vector2(128,100)
	c._set_jump_key(83)
	add_child(c)
