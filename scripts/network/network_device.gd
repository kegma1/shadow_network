extends Node
class_name NetworkDevice

@export var address: String
@export var type: String

@export var physical_device: PhysicalDevice

@onready var network_manager = find_parent("network_manager")

func find_device_by_address(address_looking_for:String):
	if address == address_looking_for:
		return self
	
	for child in get_children():
		var res = child.find_device_by_address(address_looking_for)
		if res:
			return res
	return null

