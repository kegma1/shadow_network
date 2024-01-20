@tool
extends EditorScript

func _run():
	var network_manager = get_scene().get_node("network_manager")
	for c in network_manager.get_children():
		network_manager.remove_child(c)
		c.queue_free()
	var unnamed_devicec = 0
	for dev in network_manager.queue:
		var new_node = NetworkDevice.new()
		if "hostname" in dev.properties:
			new_node.name = dev.properties["hostname"].replace("\\\"", "")
		else:
			new_node.name = "device_" + str(unnamed_devicec)
			unnamed_devicec += 1
		
		new_node.address = dev.properties["host_address"].replace("\\\"", "")
		
		network_manager.add_child(new_node)
		new_node.owner = get_scene()
		
