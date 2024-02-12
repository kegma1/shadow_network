extends NinePatchRect

signal list_updated

@onready var list_container = $MarginContainer/ScrollContainer/VBoxContainer
@onready var mail_display = $"../MailDisplay"

const MAIL_BUTTON = preload("res://sceans/main_menu/mail_button.tscn")

func populate_list():
	for mission in MissionManager.missions:
		var new_button = MAIL_BUTTON.instantiate()
		new_button.mission = mission
		list_container.add_child(new_button)
		mail_display.connect_button(new_button)


func _ready():
	populate_list()
	
