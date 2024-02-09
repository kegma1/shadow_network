extends VBoxContainer
@onready var option_button = $GridContainer/OptionButton
@onready var check_box = $GridContainer/CheckBox

func add_items():
	option_button.add_item("1080x1920")
	option_button.add_item("1080x2560")
	option_button.add_item("1440x2560")
	option_button.add_item("1440x3440")
	option_button.add_item("2160x3840")


func _ready():
	add_items()
	option_button.select(Settings.resolution_selection)
	check_box.button_pressed = Settings.fullscreened


func _on_check_box_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	
	Settings.resolution = get_viewport().size
	Settings.fullscreened = toggled_on
	option_button.disabled = toggled_on


func _on_option_button_item_selected(index):
	if not Settings.fullscreened:
		var resolution = option_button.get_item_text(index).split("x")
		Settings.resolution = Vector2(float(resolution[1]), float(resolution[0]))
		get_viewport().size = Settings.resolution
		Settings.resolution_selection = index
