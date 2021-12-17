extends Node2D


onready var Character = preload("res://Scenes/Character.tscn")
onready var Obstacle = preload("res://Scenes/Obstacle.tscn")
const keyMap = [
	[65,'a'],
	[83,'s'],
	[68,'d'],
	[70,'f'],
	[72,'h'],
	[74,'j'],
	[75,'k'],
	[76,'l']
]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_character()

func _on_ObstacleTimer_timeout():
	var o = Obstacle.instance()
	o.position = Vector2(900,500) #? idk
	add_child(o)




func _on_PlayerTimer_timeout():
	spawn_character()
func spawn_character():
	var c = Character.instance()
	c.floorNode = $Floor
	c.position = Vector2($CharacterContainer.get_child_count() * 64, 100)
	var k = keyMap.pop_front()
	c._set_jump_key(k[0])
	c._set_label(k[1])
	$CharacterContainer.add_child(c)
