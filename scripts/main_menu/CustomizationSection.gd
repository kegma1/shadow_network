extends VBoxContainer

@export var color_select_group: ButtonGroup

func _ready():
	for b in color_select_group.get_buttons():
		b.pressed.connect(_color_select_pressed)

func _color_select_pressed():
	Settings.wallpaper_color = color_select_group.get_pressed_button().color
