extends Control

## this key_sprite_textures loading thing is duplicated from Level.gd
## suggesting our structure is wrong and there should be a parent node to both scenes or a node in the tree
## that just contains these loaded textures...
## but thats too much changes for me to make rn, I'll just load it twice... next game tho
onready var KeySprite = preload("res://Scenes/KeySprite.tscn")
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

func _ready():
	$CanvasLayer2/Transition.In(1.5)

func _input(event):
	if event.is_action("ui_select") and event.is_pressed():
		start_game()
	if event.is_action("ui_cancel") and event.is_pressed():
		get_tree().quit()
	
func _on_Button_pressed():
	start_game()

func start_game():
		$TransitionSound.play()
		$CanvasLayer2/Transition.Out(1.5)

func _on_MenuMusic_finished():
	$MenuMusic.play()

func add_key_sprites():
	for key in key_sprite_textures.keys():
		yield(get_tree().create_timer(0.1), "timeout")
		var num_sprites_added = $Node/CanvasLayer/VBoxContainer/Keys.get_child_count()
		var keySprite = KeySprite.instance()
		var sprite = keySprite.get_node("Sprite")
		sprite.key = key
		sprite.up_sprite = key_sprite_textures[key].up
		sprite.down_sprite = key_sprite_textures[key].down
		sprite.position = Vector2(256 + num_sprites_added * 64, 400)
		$Node/CanvasLayer/VBoxContainer/Keys.add_child(keySprite)
	yield(get_tree().create_timer(0.1), "timeout")
	$Node/CanvasLayer/SpaceLabel.visible = true

## the signal comes back here from Transition
func _on_Transition_scene_changed():
	get_tree().change_scene("res://Scenes/Level.tscn")



func _on_Transition_transition_finished():
	add_key_sprites()
