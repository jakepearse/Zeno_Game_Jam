extends Node2D
var difficulty = 0

const charHeight = 300 #Starting y-coord of Characters
const spriteHeight = 560 #y-coord of key sprites
const character_width = 96


onready var Character = preload("res://Scenes/Character.tscn")
onready var Obstacle = preload("res://Scenes/Obstacle.tscn")
onready var Obstacle2 = preload("res://Scenes/Obstacle2.tscn")
onready var Meteor = preload("res://Scenes/MeteorTrail.tscn")
onready var KeySprite = preload("res://Scenes/KeySprite.tscn")

var obstAssort = false #whether obstacle size is randomized.
var charCount = 0
var play_time:float = 0.0
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

##onready var footstep_streams = [
##	load("res://Sounds/footStep_1.wav"),
##	load("res://Sounds/footStep_2.wav"),
##	load("res://Sounds/footStep_3.wav"),
##	load("res://Sounds/footStep_4.wav")
##]

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
	spawn_meteor()
	yield(get_tree().create_timer(1.5), "timeout") ## it's either this or create another timer...
	if obstAssort && (randi() % 2) == 1:
		var o = Obstacle.instance()
		o.position = Vector2(1020,450) #? idk
		add_child(o)
	else:
		var o = Obstacle2.instance()
		o.position = Vector2(1020,450) #? idk
		add_child(o)
	randomize()

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

func _on_PlayerTimer_timeout():
	match difficulty:
		0:
			$ObstacleTimer.start() #Begin spawning obstacles

			#FIXME: Add statement, should spawn only small obstacles
			continue #Also spawn a dino
		1:
			$ObstacleTimer.stop()

			$SecondDinoDelay.start()
		2:
			$ObstacleTimer.start()

		3:
			obstAssort = true
		_:
			charCount = $CharecterContainer.get_child_count()
			if charCount >= 8: continue # only 8 allowed
			var x = character_width + charCount * character_width ## calculate where to place the next charecter
			assign_sprite(keyMap[0]) #Create and position keysprite
			keySprite.position = Vector2(x, spriteHeight)
			spawn_character(Vector2(x, charHeight)) #Create and position character
	difficulty = difficulty + 1 #Difficulty has increased.


func spawn_character(pos):
	c = Character.instance()
	c.floorNode = $Floor
	c.position = pos
	c.jumpKey = keyMap.pop_front()

	var idx = charCount % dino_sprites.size()
	c.add_child(dino_sprites[charCount % dino_sprites.size()].instance())
	##var Footsteps = c.get_node("Footsteps")
	var random_instrument:AudioStreamPlayer = $InstrumentSoundsContainer.get_children()[randi() % $InstrumentSoundsContainer.get_child_count()-1]
	if random_instrument.get_volume_db() == -80: random_instrument.set_volume_db(0) ## set the background sound
	
	$CharecterContainer.add_child(c) ## if we keep them all together in a node its easy to count them
	
	#	You cant just switch out the frames, sadly you have to build a whole mess of stuff 1st...
	# instead make a Scene & instance that with all that animation data in there
	#FIXME: access the Frames property of c's AnimatedSprite node
	#c.get_node("AnimatedSprite").frames = dino_sprites[charCount % dino_sprites.size()]


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


func _on_SecondDinoDelay_timeout():
	charCount = $CharecterContainer.get_child_count()
	var x = character_width + charCount * character_width ## calculate where to place the next charecter
	assign_sprite(keyMap[0]) #Create and position keysprite
	keySprite.position = Vector2(x, spriteHeight)
	spawn_character(Vector2(x, charHeight)) #Create and position character


#func _on_MeteorTimer_timeout():
#	spawn_meteor()
