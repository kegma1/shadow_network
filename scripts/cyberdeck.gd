extends Node3D

@onready var main_screen = $cyberdeck/MainScreen

@export var screen_on := false : set = _set_display_on

func _set_display_on(new_state):
	if new_state:
		main_screen.show()
	else:
		main_screen.hide()

func _ready():
	main_screen.hide()
