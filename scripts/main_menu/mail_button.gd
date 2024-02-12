extends Button

signal button_pressed_with_mission(mission: Mission)

@export var mission: Mission

func _ready():
	text = mission.title

func _pressed():
	emit_signal("button_pressed_with_mission", mission)
