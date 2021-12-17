extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var MainMenu = preload("res://Scripts/MainMenu.gd")
onready var Level = preload("res://Scenes/Level.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var mainMenu = MainMenu.instance()
	MainMenu.conn 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
