@tool
extends TextureButton
class_name Desktop_icon

@export var normal: Texture2D
@export var hover: Texture2D
@export var clicked: Texture2D

@export var lable_text: String = ""

@export var app: PackedScene

@onready var label = $Label

func _ready():
	texture_normal = normal
	texture_hover = hover
	texture_pressed = clicked
	label.text = lable_text
	
func _draw():
	texture_normal = normal
	texture_hover = hover
	texture_pressed = clicked
	label.text = lable_text

func _pressed():
	if app:
		get_parent().add_child(app.instantiate())
