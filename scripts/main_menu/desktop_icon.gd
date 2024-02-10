@tool
extends TextureButton
class_name DesktopIcon

@export var normal: Texture2D
@export var hover: Texture2D
@export var clicked: Texture2D

@export var lable_text: String = ""

@export var function: IconFunction

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
	function.do(self)

