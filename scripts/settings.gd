extends Node

signal color_changed
signal wallpaper_changed

@export var wallpaper_color: Color = Color("7e5a9b"):
	set(new_color):
		wallpaper_color = new_color
		emit_signal("color_changed")

@export var selected_wallpaper: int = 0 :
	set(new_wallpaper):
		selected_wallpaper = new_wallpaper
		emit_signal("wallpaper_changed")

@export var resolution:Vector2 = Vector2(1920, 1080)
@export var resolution_selection: int = 0
@export var fullscreened: bool = false
