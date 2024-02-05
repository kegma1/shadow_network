@tool
extends TextureRect
class_name Desktop_icon

@export var normal: Texture
@export var hover: Texture
@export var clicked: Texture

func _ready():
	texture = normal

func click():
	pass
