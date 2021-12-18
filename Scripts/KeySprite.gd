extends Sprite

export var down_sprite:Texture
export var up_sprite:Texture
export var key:int

# Called when the node enters the scene tree for the first time.
func _ready():
	$Stars.emitting = true
	texture = up_sprite

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == key:
		texture = down_sprite
	elif event is InputEventKey and !event.pressed and event.scancode == key:
		texture = up_sprite
