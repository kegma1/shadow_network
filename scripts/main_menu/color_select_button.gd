extends CheckBox

@onready var color_rect = $MarginContainer/ColorRect

@export var color: Color

func _ready():
	button_pressed = Settings.wallpaper_color.is_equal_approx(color)
	color_rect.color = color
