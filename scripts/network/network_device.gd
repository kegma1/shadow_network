extends Node
class_name NetworkDevice

@export var address: String
@export var type: String

@export var physical_device: PhysicalDevice

enum InfoType {
	Adress = 1,
	Hostname = 2,
	Type = 4,
	Parent = 8,
}

@export_flags("Adress", "Hostname", "Type", "Parent") var discoverd_flags: int = 0

func discover_info(info: InfoType):
	discoverd_flags |= info

func undiscover_info(info: InfoType):
	discoverd_flags &= ~info

func is_info_discoverd(info: InfoType):
	return discoverd_flags & info != 0


@onready var network_manager = find_parent("network_manager")

func find_device_by_address(address_looking_for:String):
	if address == address_looking_for:
		return self
	
	for child in get_children():
		var res = child.find_device_by_address(address_looking_for)
		if res:
			return res
	return null

