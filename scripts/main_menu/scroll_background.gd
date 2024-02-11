extends TextureRect

@export var textures: Array[Texture] = [ 
	preload("res://textures/ui_tesxtures/icons/kijetesantakalu4.png"),
	preload("res://textures/ui_tesxtures/icons/kijetesantakalu3.png"),
	preload("res://textures/ui_tesxtures/icons/kijetesantakalu2.png"),
]

@export var selected: int = Settings.selected_wallpaper

func _ready():
	texture = textures[selected]
	material.set_shader_parameter("Color", Settings.wallpaper_color)
	Settings.color_changed.connect(func(): material.set_shader_parameter("Color", Settings.wallpaper_color))
	Settings.wallpaper_changed.connect(func(): 
		selected = Settings.selected_wallpaper
		texture = textures[selected]
	)
