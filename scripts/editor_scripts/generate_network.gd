@tool
extends EditorScript

var connections = {}
var unconnected_devices = {}
var connected_devices = []

func _run():
	var network_manager = get_scene().get_node("network_manager")
	var map = get_scene().get_node("QodotMap")
	for c in network_manager.get_children():
		network_manager.remove_child(c)
		c.queue_free()

	for dev in map.get_children():
		if dev is PhysicalDevice:
			var new_node = create_network_device(dev)
			
			if "devices" in dev.properties:
				var devices = dev.properties["devices"].split(",")
				for d in devices:
					connections[d] = new_node.address
			unconnected_devices[new_node.address] = new_node
		
	for current_dev_address in connections:
		var current_dev = unconnected_devices[current_dev_address]
		
		var parent_dev_address = connections[current_dev_address]
		var parent_dev = unconnected_devices[parent_dev_address]
		
		if parent_dev.type == "router":
			if parent_dev not in network_manager.get_children():
				network_manager.add_child(parent_dev)
				connected_devices.append(parent_dev)
			parent_dev.add_child(current_dev)
		else:
			parent_dev.add_child(current_dev)
		connected_devices.append(current_dev)

	for dev in connected_devices:
		dev.owner = get_scene()
	

func find_device_by_address(address, devices):
	for dev_address in devices:
		if dev_address == address:
			return devices[dev_address]
	return null

func create_network_device(dev: PhysicalDevice) -> NetworkDevice:
	var new_node = NetworkDevice.new()
	new_node.address = dev.properties["host_address"]
	new_node.type = dev.properties["device_type"]
	
	dev.abstract_device = new_node
	new_node.physical_device = dev
	
	if "hostname" in dev.properties:
		new_node.name = dev.properties["hostname"]
	else:
		new_node.name = "device_" + dev.properties["host_address"]
	
	return new_node
