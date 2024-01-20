@tool
class_name PhysicalDevice
extends Node3D

@export var properties: Dictionary = {} : 
	set(value):
		properties = value
		if Engine.is_editor_hint():
			#get_parent().build_complete.connect(_on_build_complete)
			get_parent().get_parent().get_node("network_manager").register_device(self)

#func  _ready():
	#if Engine.is_editor_hint():
		##get_parent().build_complete.connect(_on_build_complete)
		#get_parent().get_parent().get_node("network_manager").register_device(self)
		

func _on_build_complete():
	get_parent().get_parent().get_node("network_manager").register_device(self)
