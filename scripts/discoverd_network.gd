extends Node

var subnets = {}
var current_subnet = null

func connected_to_subnet(ip_address:String):
	var subnet_ip = ip_address.split(".")
	assert(subnet_ip.size() == 4, "address is not correct [%s]" % ip_address)
	subnet_ip.remove_at(3)
	print(subnet_ip)
	
	if subnet_ip not in subnets:
		subnets[subnet_ip] = NetworkNode.new()
		subnets[subnet_ip].host_address = ip_address
	
	current_subnet = subnets[subnet_ip]

func dissconnected_from_subnet():
	current_subnet = null

func discover_info(new_info):
	assert(current_subnet, "not connected to or not notified about network connection")
	var nodes = {}
	
	for info in new_info:
		var ip = info.host_address
		if ip not in nodes:
			nodes[ip] = NetworkNode.new()
			nodes[ip].host_address = ip
			nodes[ip].host_name = info.host_name if info.host_name else "Unknown"
		else:
			nodes[ip].host_name = info.host_name if info.host_name else nodes[ip].host_name
		
	for info in new_info:
		var node = nodes[info.host_address]
		if not info.connected_to:
			continue
		for connected_ip in info.connected_to:
			if connected_ip and connected_ip in nodes:
				var connected_node = nodes[connected_ip]
				if connected_node not in node.children:
					node.children.append(connected_node)
					
	var new_root = find_new_root(nodes, current_subnet.host_address)
	
	if new_root and new_root != current_subnet.host_address:
		current_subnet = nodes[new_root]

func find_new_root(nodes, current_root_ip):
	print(nodes)

class InfoObject:
	var host_address
	var host_name
	var connected_to
	
	func _init(ip = null, hostname = null, connected_to = null):
		host_address = ip
		host_name = hostname
		connected_to = connected_to
	
class NetworkNode:
	var host_address
	var host_name
	var children
	
	func _init():
		host_address = "Unknown"
		host_name = "Unknown"
		children = [] 

