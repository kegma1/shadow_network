extends VBoxContainer

@export var color_select_group: ButtonGroup

@onready var wallpaper_selection = $GridContainer/WallpaperSelection

func _ready():
	add_items()
	
	wallpaper_selection.select(Settings.selected_wallpaper)
	
	for b in color_select_group.get_buttons():
		b.pressed.connect(_color_select_pressed)

func add_items():
	wallpaper_selection.add_item("ZigZag")
	wallpaper_selection.add_item("Squares")
	wallpaper_selection.add_item("Kijetesantakalu")

func _color_select_pressed():
	Settings.wallpaper_color = color_select_group.get_pressed_button().color


func _on_wallpaper_selection_item_selected(index):
	Settings.selected_wallpaper = index
