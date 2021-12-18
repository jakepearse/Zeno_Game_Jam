extends Node2D

const charHeight = 300 #Starting y-coord of Characters
const spriteHeight = 560 #y-coord of key sprites

var difficulty = 0 #An int that increments with every timeout of PlayerTimer.
#Evaluated in a match (think switch) statement to determine the next modifier.

onready var Character = preload("res://Scenes/Character.tscn")
onready var Obstacle = preload("res://Scenes/Obstacle.tscn")

onready var keySpriteA = preload("res://Scenes/Key Sprites/Key Sprite A.tscn")
onready var keySpriteD = preload("res://Scenes/Key Sprites/Key Sprite D.tscn")
onready var keySpriteS = preload("res://Scenes/Key Sprites/Key Sprite S.tscn")
onready var keySpriteF = preload("res://Scenes/Key Sprites/Key Sprite F.tscn")
onready var keySpriteH = preload("res://Scenes/Key Sprites/Key Sprite H.tscn")
onready var keySpriteJ = preload("res://Scenes/Key Sprites/Key Sprite J.tscn")
onready var keySpriteK = preload("res://Scenes/Key Sprites/Key Sprite K.tscn")
onready var keySpriteL = preload("res://Scenes/Key Sprites/Key Sprite L.tscn")

var keyMap = [KEY_A, KEY_S, KEY_D, KEY_F, KEY_H, KEY_J, KEY_K, KEY_L]

var c:Node #New character spawns will be assigned to this variable.
var keySprite:Node #New Keysprite spawns will be assigned to this var.
	
func _ready():
	randomize() #Set a random seed for RNG
	keyMap.shuffle() #Randomize the order that the keys will be introduced in

func _on_ObstacleTimer_timeout():
	var o = Obstacle.instance()
	o.position = Vector2(900,500) #? idk
	add_child(o)

func _on_PlayerTimer_timeout():
	match difficulty:
		0:
			assign_sprite(keyMap[0])
			keySprite.position = Vector2(64, 560)
			
			spawn_character()
			c.position = Vector2(64, 300)

		1:
			assign_sprite(keyMap[0])
			keySprite.position = Vector2(64*2, spriteHeight)
			
			spawn_character()
			c.position = Vector2(64 * 2, charHeight)
		
		2:
			assign_sprite(keyMap[0])
			keySprite.position = Vector2(64 * 3, spriteHeight)
			
			spawn_character()
			c.position = Vector2(64 * 3, charHeight)
		3:
			assign_sprite(keyMap[0])
			keySprite.position = Vector2(64 * 4, spriteHeight)
			
			spawn_character()
			c.position = Vector2(64 * 4, charHeight)
		4:
			assign_sprite(keyMap[0])
			keySprite.position = Vector2(64 * 5, spriteHeight)
			
			spawn_character()
			c.position = Vector2(64 * 5, charHeight)
	difficulty = difficulty + 1
	
func spawn_character():
	c = Character.instance()
	c.floorNode = $Floor
	
	c.jumpKey = keyMap.pop_front()
	add_child(c)

func assign_sprite(key):
	match key:
		KEY_A:
			keySprite = keySpriteA.instance()
		KEY_S:
			keySprite = keySpriteS.instance()
		KEY_D:
			keySprite = keySpriteD.instance()
		KEY_F:
			keySprite = keySpriteF.instance()
		KEY_H:
			keySprite = keySpriteH.instance()
		KEY_J:
			keySprite = keySpriteJ.instance()
		KEY_K:
			keySprite = keySpriteK.instance()
		KEY_L:
			keySprite = keySpriteL.instance()
	add_child(keySprite)
