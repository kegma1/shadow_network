extends Node

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

func get_standard_gateway(address: String) -> String:
	var octets := address.split(".")
	octets[-1] = "1"
	return".".join(octets) 
	

func ping(dest_address: String, from_address: String):
	if not is_same_subnet(dest_address, from_address):
		return "Ping request could not find host %s" % dest_address
	
	var standard_gateway = get_standard_gateway(from_address)
	var subnet: NetworkDevice
	for net in get_children():
		if net.address == standard_gateway:
			subnet = net
	
	if not subnet:
		return "Ping request could not find host %s" % dest_address
		
	var device = subnet.find_device_by_address(dest_address)
	if not device:
		return "Ping request could not find host %s" % dest_address
	
	var new_info = DiscoverdNetwork.InfoObject.new(dest_address)
	
	DiscoverdNetwork.discover_info([new_info])
	
	return "Reply from %s: bytes=32 time=%sms TTL=60" % [dest_address, randi_range(1, 59)]

func traceroute(dest_address: String, from_address: String):
	if not is_same_subnet(dest_address, from_address):
		return "Failed to find host %s" % dest_address
	
	var standard_gateway = get_standard_gateway(from_address)
	var subnet: NetworkDevice
	for net in get_children():
		if net.address == standard_gateway:
			subnet = net
	
	if not subnet:
		return "Failed to find host %s" % dest_address
		
	var from = subnet.find_device_by_address(dest_address)
	if not from:
		return "Failed to find host %s" % dest_address
	var to = subnet.find_device_by_address(from_address)
	if not to:
		return "Failed to find host %s" % from_address
		
	var path_from_meet = find_path_to_meet(from, to)
	var path_to_meet = find_path_to_meet(to, from)
	path_to_meet.reverse()
	path_from_meet.pop_back()
	path_from_meet.append_array(path_to_meet)
	path_from_meet.reverse()
	var output = [
		"Tracing route to %s" % dest_address,
		"Step\tAddress"
		]
	for i in range(path_from_meet.size()):
		output.push_back("%0*d\t%s" % [4,i + 1, path_from_meet[i].address])
	return output
	
			
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
