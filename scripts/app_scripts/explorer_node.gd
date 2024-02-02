extends Control

@export var spaceing: int = 15

@export var hostname: String = "???"
@export var address: String = "???"
@export var type: String = "???"

@onready var children = $HBoxContainer

@onready var panel = $NinePatchRect

@onready var line = $Line2D


var width := 208
var height := 86

func _ready():
	width = panel.size.x
	height = panel.size.y
	$NinePatchRect/RichTextLabel.text = "Hostname: %s\nIP-Address: %s\nType: %s" % [hostname, address, type]
	children.position.y = height + spaceing
	children.add_theme_constant_override("separation", width + spaceing)


func _process(delta):
	var child_nodes = children.get_children()
	for cn in child_nodes:
		if cn.line.get_point_count() < 2:
			var pos = cn.line.to_local($NinePatchRect/Node2D.global_position)
			cn.line.add_point(pos)

func append_node(node):
	children.add_child(node)


