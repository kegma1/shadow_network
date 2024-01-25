@tool
extends VBoxContainer
@onready var button = $TextureButton
@onready var lable = $Label

@export var text: String = "Placeholder"
@export var normal_texture: Texture = load("res://textures/ui_tesxtures/icons/placeholder_icon_normal.png")
@export var pressed_texture: Texture = load("res://textures/ui_tesxtures/icons/placeholder_icon_pressed.png")
@export var hover_texture: Texture = load("res://textures/ui_tesxtures/icons/placeholder_icon_hover.png")
@export var disabled_texture: Texture = load("res://textures/ui_tesxtures/icons/placeholder_icon_disabled.png")

@export var owned := false

@export var application: PackedScene

func _draw():
	button.disabled = true
	if owned:
		lable.text = text
		button.disabled = false
	button.texture_normal = normal_texture
	button.texture_pressed = pressed_texture
	button.texture_hover = hover_texture
	button.texture_disabled = disabled_texture

func _ready():
	button.disabled = true
	if owned:
		lable.text = text
		button.disabled = false
	button.texture_normal = normal_texture
	button.texture_pressed = pressed_texture
	button.texture_hover = hover_texture
	button.texture_disabled = disabled_texture
