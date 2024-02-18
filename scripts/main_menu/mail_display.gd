extends NinePatchRect

@export var mail_buttons: ButtonGroup

@onready var rich_text_label = $MarginContainer/VBoxContainer/TextDisplay/MarginContainer/RichTextLabel
@onready var from_label = $MarginContainer/VBoxContainer/Header/MarginContainer/HBoxContainer/VBoxContainer/FromLabel
@onready var to_label = $MarginContainer/VBoxContainer/Header/MarginContainer/HBoxContainer/VBoxContainer/ToLabel
@onready var texture_rect = $MarginContainer/VBoxContainer/Header/MarginContainer/HBoxContainer/AspectRatioContainer/NinePatchRect/MarginContainer/TextureRect

var current_mission: Mission

func _ready():
	pass

func connect_button(b: Button):
	b.button_pressed_with_mission.connect(_button_pressed)

func _button_pressed(mission: Mission):
	current_mission = mission
	
	rich_text_label.text = mission.mission_text
	texture_rect.texture = mission.sender.photo
	from_label.text = "From: " + mission.sender.name
	to_label.text = "To: V"





func _on_rich_text_label_meta_clicked(meta):
	if meta == "mission":
		get_tree().change_scene_to_packed(current_mission.level.map)

