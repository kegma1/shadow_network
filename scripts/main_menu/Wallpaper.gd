extends TextureRect

func _ready():
	material.set_shader_parameter("Color", Settings.wallpaper_color)
	Settings.color_changed.connect(func(): material.set_shader_parameter("Color", Settings.wallpaper_color))
