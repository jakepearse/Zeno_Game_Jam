extends Node2D
var difficulty = 0
var musicIterator = 0

const charHeight = 300 #Starting y-coord of Characters
const spriteHeight = 560 #y-coord of key sprites
const character_width = 96

onready var arp_bells = $LevelBackGroundMusic/Arp_Bells
onready var guitar = $LevelBackGroundMusic/Guitar
onready var hats = $LevelBackGroundMusic/Hats
onready var piano_bass = $LevelBackGroundMusic/Piano_Bass
onready var rim = $LevelBackGroundMusic/Rim
onready var sax = $LevelBackGroundMusic/Sax
onready var shaker = $LevelBackGroundMusic/Shaker
onready var snare_kick = $LevelBackGroundMusic/Snare_Kick

onready var spawnSound = $SpawnSound

onready var music_array = [arp_bells, guitar, hats, rim, sax, shaker, snare_kick]

onready var Character = preload("res://Scenes/Character.tscn")
onready var Obstacle = preload("res://Scenes/Obstacle.tscn")

onready var KeySprite = preload("res://Scenes/KeySprite.tscn")

## onready var CharacterCoda = c.get_node("CharacterCoda")

## load the textures so we can switch the keysprites in per instance
onready var key_sprite_textures = {
	KEY_A: { 'up': load("res://Sprites/Test/A-Up.png"), 'down': load("res://Sprites/Test/A-Down.png") },
	KEY_S: { 'up' : load("res://Sprites/Test/S-Up.png"), 'down': load("res://Sprites/Test/S-Down.png") },
	KEY_D: { 'up' : load("res://Sprites/Test/D-Up.png"), 'down': load("res://Sprites/Test/D-Down.png") },
	KEY_F: { 'up' : load("res://Sprites/Test/F-Up.png"), 'down': load("res://Sprites/Test/F-Down.png") },
	KEY_H: { 'up' : load("res://Sprites/Test/H-Up.png"), 'down': load("res://Sprites/Test/H-Down.png") },
	KEY_J: { 'up' : load("res://Sprites/Test/J-Up.png"), 'down': load("res://Sprites/Test/J-Down.png") },
	KEY_K: { 'up' : load("res://Sprites/Test/K-Up.png"), 'down': load("res://Sprites/Test/K-Down.png") },
	KEY_L: { 'up' : load("res://Sprites/Test/L-Up.png"), 'down': load("res://Sprites/Test/L-Down.png") }
}

var keyMap = [KEY_A, KEY_S, KEY_D, KEY_F, KEY_H, KEY_J, KEY_K, KEY_L]

var c:Node #New character spawns will be assigned to this variable.
var keySprite:Sprite#:Sprite #New Keysprite spawns will be assigned to this var.
	
func _ready():
	randomize() #Set a random seed for RNG
	keyMap.shuffle() #Randomize the order that the keys will be introduced in
	##character_audio_streams.shuffle()
	## CharacterCoda.stream = character_audio_streams.pop_front() ## set the background sound

func _on_ObstacleTimer_timeout():
#	return # begone foul obstacles
	var o = Obstacle.instance()
	o.position = Vector2(900,500) #? idk
	add_child(o)

func _on_PlayerTimer_timeout():
	match difficulty:
		0:
			$ObstacleTimer.start() #Begin spawning obstacles
			continue #Also spawn a dino
		_:
			var charCount = $CharecterContainer.get_child_count()
			var x = character_width + charCount * character_width ## calculate where to place the next charecter
			assign_sprite(keyMap[0]) #Create and position keysprite
			keySprite.position = Vector2(x, spriteHeight)
			spawn_character(Vector2(x, charHeight)) #Create and position character
	difficulty = difficulty + 1 #Difficulty has increased.


func spawn_character(pos):
	spawnSound.play()
	c = Character.instance()
	c.floorNode = $Floor
	c.position = pos
	c.jumpKey = keyMap.pop_front()
	if music_array[musicIterator].get_volume_db() < (-3):
		music_array[musicIterator].set_volume_db(-3)
		musicIterator += 1
	$CharecterContainer.add_child(c) ## if we keep them all together in a node its easy to count them

func assign_sprite(key):
	var k = KeySprite.instance()
	keySprite = k.get_node("Sprite")
	keySprite.key = key
	keySprite.up_sprite = key_sprite_textures[key].up
	keySprite.down_sprite = key_sprite_textures[key].down
	## the keySprite is getting positioned in the parent function, on_player_timeout
	add_child(k)


func _on_LevelBackGroundMusic_finished():
	$LevelBackGroundMusic.play()
