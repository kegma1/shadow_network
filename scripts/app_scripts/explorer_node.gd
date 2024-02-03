extends Control

@export var spaceing: int = 15

@export var hostname: String = "???"
@export var address: String = "???"
@export var type: String = "???"

@onready var children = $HBoxContainer

@onready var standard_panel = $standard
@onready var disabled_panel = $disabled
@onready var highlighted_panel = $highligted

@onready var line = $Line2D

var current_panel: NinePatchRect

enum State {
	standard,
	disabled,
	highlighted
}

@export var state:State = State.standard

func set_state():
	standard_panel.hide()
	disabled_panel.hide()
	highlighted_panel.hide()
	
	match state:
		State.standard:
			current_panel = standard_panel
			standard_panel.show()
		State.disabled:
			current_panel = disabled_panel
			disabled_panel.show()
		State.highlighted:
			current_panel = highlighted_panel
			highlighted_panel.show()


var width := 208
var height := 86

func _ready():
	set_state()
	
	current_panel.get_child(0).text = "Hostname: %s\nIP-Address: %s\nType: %s" % [hostname, address, type]
	children.position.y = height + spaceing
	children.add_theme_constant_override("separation", width + spaceing)


func _process(delta):
	var child_nodes = children.get_children()
	for cn in child_nodes:
		if cn.line.get_point_count() < 2:
			var pos = cn.line.to_local($Node2D.global_position)
			cn.line.add_point(pos)

func append_node(node):
	children.add_child(node)


