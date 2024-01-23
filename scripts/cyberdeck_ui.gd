extends Control

@export var cyberdeck_path: NodePath

var cyberdeck

func _ready():
	cyberdeck = get_node(cyberdeck_path)
