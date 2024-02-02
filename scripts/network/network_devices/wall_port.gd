extends NetworkDevice
class_name AbstractWallPort

@export var connected_to = false :
	set(new_value):
		connected_to = new_value
		if connected_to:
			discover_info(InfoType.Adress|InfoType.Hostname|InfoType.Type)
		else:
			undiscover_info(InfoType.Adress|InfoType.Hostname|InfoType.Type)

func discover_info(info: InfoType):
	if connected_to:
		discoverd_flags |= info

func get_discoverd_info():
	if connected_to:
		var discoverd_info = {}
	
		if is_info_discoverd(InfoType.Adress):
			discoverd_info["address"] = address
		if is_info_discoverd(InfoType.Hostname):
			discoverd_info["hostname"] = hostname
		if is_info_discoverd(InfoType.Type):
			discoverd_info["type"] = type
		if is_info_discoverd(InfoType.Parent):
			if get_parent() is NetworkDevice:
				discoverd_info["parent"] = get_parent()
	
		if discoverd_info == {}:
			return null
		return discoverd_info
	return null

func _ready():
	var terminal = RefStore.current_terminal
	var cyberdeck = terminal.cyberdeck
	cyberdeck.connect_to_port.connect(_on_connect_to_port)
	cyberdeck.disconnect_from_port.connect(_on_disconnect_from_port)

func _on_connect_to_port(port):
	if port == self:
		connected_to = true

func _on_disconnect_from_port():
	connected_to = false
