extends IconFunction
class_name AppLauncher

@export var app: PackedScene


func do(icon: DesktopIcon):
	if app:
		icon.get_parent().add_child(app.instantiate())
