extends Sprite

export var downSprite:Texture
var upSprite = texture
export var key:int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == key:
		texture = downSprite
	elif event is InputEventKey and !event.pressed and event.scancode == key:
		texture = upSprite
