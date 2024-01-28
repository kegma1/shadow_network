@tool
extends VBoxContainer
@onready var button = $TextureButton
@onready var lable = $Label

@export var app_launcher_path: NodePath
@export var text: String = "Placeholder"
@export var normal_texture: Texture = load("res://textures/ui_tesxtures/icons/placeholder_icon_normal.png")
@export var pressed_texture: Texture = load("res://textures/ui_tesxtures/icons/placeholder_icon_pressed.png")
@export var hover_texture: Texture = load("res://textures/ui_tesxtures/icons/placeholder_icon_hover.png")
@export var disabled_texture: Texture = load("res://textures/ui_tesxtures/icons/placeholder_icon_disabled.png")

@export var owned := false

@export var application_path: PackedScene 

var application
var app_launcher

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
		application = application_path.instantiate()
	button.texture_normal = normal_texture
	button.texture_pressed = pressed_texture
	button.texture_hover = hover_texture
	button.texture_disabled = disabled_texture
	
	app_launcher = get_node(app_launcher_path)


func _on_texture_button_pressed():
	assert(application, "no application given")
	assert(app_launcher, "cant find application")

	var application_monitor = app_launcher.get_parent()
	if application not in application_monitor.get_children():
		application_monitor.add_child(application)
	application_monitor.current_tab = application_monitor.get_tab_idx_from_control(application)
