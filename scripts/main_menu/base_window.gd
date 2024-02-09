extends VBoxContainer
@onready var color_rect = $Container/MarginContainer/HBoxContainer/TopBar/MarginContainer/ColorRect

func _ready():
	color_rect.material.set_shader_parameter("Color", Settings.wallpaper_color)
	Settings.color_changed.connect(func(): color_rect.material.set_shader_parameter("Color", Settings.wallpaper_color))

func _on_close_button_pressed():
	assert(get_parent() is Control, "this should not happen, the base window should always, be a child of a control node")
	get_parent().queue_free()


func _on_minimise_button_pressed():
	pass # Replace with function body.
