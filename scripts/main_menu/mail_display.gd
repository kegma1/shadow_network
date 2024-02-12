extends NinePatchRect

@export var mail_buttons: ButtonGroup
@onready var rich_text_label = $MarginContainer/NinePatchRect/MarginContainer/RichTextLabel

func _ready():
	pass

func connect_button(b: Button):
	b.button_pressed_with_mission.connect(_button_pressed)

func _button_pressed(mission: Mission):
	rich_text_label.text = mission.mission_text



