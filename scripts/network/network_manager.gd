extends Node
class_name NetworkManager

signal tree_updated

func _ready():
	RefStore.current_network_manager = self

func is_same_subnet(ip1: String, ip2: String) -> bool:
	# Split the IP addresses into octets
	var octets1 := ip1.split(".")
	var octets2 := ip2.split(".")

	# Ensure both IPs have 4 octets
	if octets1.size() != 4 or octets2.size() != 4:
		return false

	# Check if the first three octets are the same
	for i in range(0, 2):
		if int(octets1[i]) != int(octets2[i]):
			return false

	# Check if the last octet is within the same subnet (subnet mask 255.255.255.0)
	if int(octets1[3]) / 256 != int(octets2[3]) / 256:
		return false

	return true

func get_standard_gateway_address(address: String) -> String:
	var octets := address.split(".")
	octets[-1] = "1"
	return".".join(octets) 

## returns the subnetdevice that the address given belong to, 
## returns null if device dosnt exist in any subnet or if the subnet does not exist
func get_subnet_device(address: String):
	var standard_gateway = get_standard_gateway_address(address)
	var subnet: NetworkDevice
	for net in get_children():
		if net.address == standard_gateway:
			subnet = net
			
	if not subnet: return null
	var device_in_subnet = subnet.find_device_by_address(address)
	if not device_in_subnet: return null
	
	return subnet

func ping(dest_address: String, from_address: String):
	if not is_same_subnet(dest_address, from_address):
		return null
	
	var standard_gateway = get_standard_gateway_address(from_address)
	var subnet: NetworkDevice
	for net in get_children():
		if net.address == standard_gateway:
			subnet = net
	
	if not subnet:
		return null
		
	var device = subnet.find_device_by_address(dest_address)
	if not device:
		return null
	if device is AbstractWallPort and not device.connected_to:
		return null
	
	device.discover_info(NetworkDevice.InfoType.Adress)
	emit_signal("tree_updated")
	return dest_address

func traceroute(dest_address: String, from_address: String):
	if not is_same_subnet(dest_address, from_address):
		return null
	
	var standard_gateway = get_standard_gateway_address(from_address)
	var subnet: NetworkDevice
	for net in get_children():
		if net.address == standard_gateway:
			subnet = net
	if not subnet: return null
		
	var from = subnet.find_device_by_address(dest_address)
	if not from: return null
	if from is AbstractWallPort and not from.connected_to:
		return null
	
	var to = subnet.find_device_by_address(from_address)
	if not to: return null
	var output = []
	if dest_address == from_address:
		output.push_back(from)
		from.discover_info(NetworkDevice.InfoType.Adress)
		emit_signal("tree_updated")
		return output
	
	var path_from_meet = find_path_to_meet(from, to)
	var path_to_meet = find_path_to_meet(to, from)
	path_to_meet.reverse()
	path_from_meet.pop_back()
	path_from_meet.append_array(path_to_meet)
	path_from_meet.reverse()

	for i in range(path_from_meet.size()):
		path_from_meet[i].discover_info(NetworkDevice.InfoType.Adress)
		if path_from_meet[i].get_parent() in path_from_meet:
			path_from_meet[i].discover_info(NetworkDevice.InfoType.Parent)
		output.push_back(path_from_meet[i])
	emit_signal("tree_updated")
	return output
	
func host(dest_address: String, from_address: String):
	if not is_same_subnet(dest_address, from_address):
		return null
	
	var standard_gateway = get_standard_gateway_address(from_address)
	var subnet: NetworkDevice
	for net in get_children():
		if net.address == standard_gateway:
			subnet = net
	
	if not subnet:
		return null
		
	var device = subnet.find_device_by_address(dest_address)
	if not device:
		return null
	if device is AbstractWallPort and not device.connected_to:
		return null
	if not device.is_info_discoverd(NetworkDevice.InfoType.Adress):
		return null
	
	device.discover_info(NetworkDevice.InfoType.Hostname | NetworkDevice.InfoType.Type)
	emit_signal("tree_updated")
	return [device.hostname, device.type]
		
	

func find_path_to_meet(from, to):
	var path:Array[NetworkDevice] = [from]
	if from == to:
		return path
	while true:
		if "find_device_by_address" not in path[-1].get_parent():
			return path
		var parent = path[-1].get_parent()
		var res = parent.find_device_by_address(to.address)
		if not res:
			path.push_back(parent)
		else:
			path.push_back(parent)
			return path
