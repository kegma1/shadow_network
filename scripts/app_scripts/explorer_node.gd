extends Control

@export var spaceing: int = 15

@export var hostname: String = "???"
@export var address: String = "???"
@export var type: String = "???"

@onready var children = $HBoxContainer

@onready var panel = $NinePatchRect

var width := 208
var height := 86

func _ready():
	width = panel.size.x
	height = panel.size.y
	$NinePatchRect/RichTextLabel.text = "Hostname: %s\nIP-Address: %s\nType: %s" % [hostname, address, type]
	children.position.y = height + spaceing
	children.add_theme_constant_override("separation", width + spaceing)
func append_node(node):
	children.add_child(node)
