extends Control

@export var hostname: String = "???"
@export var address: String = "???"
@export var type: String = "???"

@onready var children = $HBoxContainer


func _ready():
	$NinePatchRect/RichTextLabel.text = "Hostname: %s\nIP-Address: %s\nType: %s" % [hostname, address, type]

func append_node(node):
	children.add_child(node)
