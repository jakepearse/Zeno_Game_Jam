extends Node2D
var difficulty = 0

const key_sprite_height = 560 #y-coord of key sprites
const char_height = 300 #Starting y-coord of Characters
const character_width = 96


onready var SmallBolder = preload("res://Scenes/SmallObstacle.tscn")
onready var Character = preload("res://Scenes/Character.tscn")
onready var Obstacle = preload("res://Scenes/Obstacle.tscn")
onready var Meteor = preload("res://Scenes/MeteorTrail.tscn")
onready var KeySprite = preload("res://Scenes/KeySprite.tscn")
#var charCount = 0
var play_time:float = 0.0
var random_sized_obstacles: bool = false
onready var obstacles = [SmallBolder.instance(),SmallBolder.instance(),SmallBolder.instance()];
## load the textures so we can switch the keysprites in per instance
onready var key_sprite_textures = {
	KEY_A: { 'up': preload("res://Sprites/Test/A-Up.png"), 'down': preload("res://Sprites/Test/A-Down.png") },
	KEY_S: { 'up' : preload("res://Sprites/Test/S-Up.png"), 'down': preload("res://Sprites/Test/S-Down.png") },
	KEY_D: { 'up' : preload("res://Sprites/Test/D-Up.png"), 'down': preload("res://Sprites/Test/D-Down.png") },
	KEY_F: { 'up' : preload("res://Sprites/Test/F-Up.png"), 'down': preload("res://Sprites/Test/F-Down.png") },
	KEY_H: { 'up' : preload("res://Sprites/Test/H-Up.png"), 'down': preload("res://Sprites/Test/H-Down.png") },
	KEY_J: { 'up' : preload("res://Sprites/Test/J-Up.png"), 'down': preload("res://Sprites/Test/J-Down.png") },
	KEY_K: { 'up' : preload("res://Sprites/Test/K-Up.png"), 'down': preload("res://Sprites/Test/K-Down.png") },
	KEY_L: { 'up' : preload("res://Sprites/Test/L-Up.png"), 'down': preload("res://Sprites/Test/L-Down.png") }
}

onready var footstep_streams = [
	load("res://Sounds/footStep_1.wav"),
	load("res://Sounds/footStep_2.wav"),
	load("res://Sounds/footStep_3.wav"),
	load("res://Sounds/footStep_4.wav")
]

# changed to animation scenes
onready var Trex = preload("res://Scenes/DinoAnimations/TRex.tscn")
onready var Stego = preload("res://Scenes/DinoAnimations/Stego.tscn")
onready var Triceratops = preload("res://Scenes/DinoAnimations/Triceratops.tscn")
onready var Bronto = preload("res://Scenes/DinoAnimations/Bronto.tscn")
onready var dino_sprites = [Trex, Stego, Triceratops, Bronto]


var keyMap = [KEY_A, KEY_S, KEY_D, KEY_F, KEY_H, KEY_J, KEY_K, KEY_L]

var c:Node #New character spawns will be assigned to this variable.
var keySprite:Sprite#:Sprite #New Keysprite spawns will be assigned to this var.
	
func _ready():
	$CanvasLayer/Transition.In (1.0)
	randomize() #Set a random seed for RNG
	keyMap.shuffle() #Randomize the order that the keys will be introduced in


func _process(delta):
	play_time = play_time + delta;
	$Control/Label.text = "You have survived for %0.2f Million Years!" % play_time

func _on_ObstacleTimer_timeout():
#	return # begone foul obstacles
	if obstacles.size() == 0:
		return
	print(obstacles)
	var o = obstacles.pop_front()
	spawn_meteor()
	yield(get_tree().create_timer(1.5), "timeout") ## wait for the meteor animation
	o.position = Vector2(1020,450) #? idk
	add_child(o)


func spawn_meteor():
	var meteor = Meteor.instance()
	$MeteorContainer.add_child(meteor)
	var s = $MeteorContainer.get_node("Sprite")
	$MeteorTween.interpolate_property(
		s,
		'position', ## property
		Vector2(0, 0), ## from
		Vector2(1700, 500), ## to
		1.5, ## dur
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	$MeteorTween.interpolate_property(
		s,
		'scale', ## property
		Vector2(0.1, 0.1), ## from
		Vector2(2, 2), ## to
		1.5, ## dur
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	$MeteorTween.start() 

func _on_DinoTimer_timeout():
	# what we want is some amount of meteors then a pause to spawn a new guy then fire off
	#	some meteors again
	if obstacles.size() > 0 :
		return
	var count = $CharacterContainer.get_child_count()
	if count >= 8:
		return # only 8 allowed
	match count:
		1: 	obstacles.append(Obstacle.instance())
		2:	
			
			$DinoTimer.wait_time = 6
			$ObstacleTimer.wait_time = 4
		3:
			$DinoTimer.wait_time = 5
			obstacles.append(Obstacle.instance())
			obstacles.append(Obstacle.instance())
			
		4:
			random_sized_obstacles = true
		_:
			pass
	var o
	for i in randi() % count + count/2:
		if (random_sized_obstacles):
			if (randi() % 100 < 50):
				o = Obstacle
			else: 
				o = SmallBolder
		else: o = SmallBolder
		obstacles.append(o.instance())
	var x = character_width + count * character_width ## calculate where to place the next charecter
	spawn_keysprite(keyMap[0]) #Create and position keysprite
	keySprite.position = Vector2(x, key_sprite_height)
	print('spawning in dinotimeout')
	spawn_character(Vector2(x, char_height)) #Create and position character

func spawn_character(pos):
	c = Character.instance()
	c.floorNode = $Floor
	c.position = pos
	c.jumpKey = keyMap.pop_front()
	var char_count = $CharacterContainer.get_child_count()
	var animated_sprite = dino_sprites[char_count % dino_sprites.size()].instance()
	var sprite_node = animated_sprite.get_node("AnimatedSprite")
	sprite_node = animated_sprite
	c.add_child(animated_sprite)
	var Footsteps = c.get_node("Footsteps")
	var random_instrument:AudioStreamPlayer = $InstrumentSoundsContainer.get_children()[randi() % $InstrumentSoundsContainer.get_child_count()-1]
	if random_instrument.get_volume_db() == -80: random_instrument.set_volume_db(0) ## set the background sound
	Footsteps.stream = footstep_streams[randi() % footstep_streams.size()] ## set the footstep sound
	$CharacterContainer.add_child(c) ## if we keep them all together in a node its easy to count them

func spawn_keysprite(key):
	var k = KeySprite.instance()
	keySprite = k.get_node("Sprite")
	keySprite.key = key
	keySprite.up_sprite = key_sprite_textures[key].up
	keySprite.down_sprite = key_sprite_textures[key].down
	## the keySprite is getting positioned in the parent function
	add_child(k)

func _on_LevelBackGroundMusic_finished():
	$LevelBackGroundMusic.play()

func _on_IntroTimer_timeout():
	spawn_keysprite(keyMap[0]) #Create and position keysprite
	keySprite.position = Vector2(character_width, key_sprite_height)
	spawn_character(Vector2(character_width, char_height)) #Create and position character
	$ObstacleTimer.start()
	$DinoTimer.start()
