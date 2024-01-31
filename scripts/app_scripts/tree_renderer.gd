extends Node2D

var current_port: NetworkDevice = null
var current_subnet: NetworkDevice = null
var cyberdeck
var network_manager
var terminal

func _ready():
	terminal = RefStore.current_terminal
	cyberdeck = terminal.cyberdeck
	network_manager = RefStore.current_network_manager
	
	if terminal.current_port:
		current_port = terminal.current_port
		current_subnet = network_manager.get_subnet_device(current_port.address)

	cyberdeck.connect_to_port.connect(_on_connect_to_port)
	cyberdeck.disconnect_from_port.connect(_on_disconnect_from_port)
	network_manager.tree_updated.connect(_rerender)

func _rerender():
	if current_subnet:
		render(current_subnet)
	
func _on_connect_to_port(port):
	# may change this later if vpns or simiular gets added 🤷‍♂️
	if current_port:
		return
	
	current_port = port
	current_subnet = network_manager.get_subnet_device(current_port.address)
	assert(current_port, "there is something wrong with the network")
	render(current_subnet)
	
	
func _on_disconnect_from_port():
	if current_port:
		pass
	current_port = null

func render(dev:NetworkDevice):
	if dev.is_info_discoverd(NetworkDevice.InfoType.Adress):
		print(dev.address)
	if dev.is_info_discoverd(NetworkDevice.InfoType.Hostname):
		print(dev.name)
	if dev.is_info_discoverd(NetworkDevice.InfoType.Type):
		print(dev.type)
	if dev.is_info_discoverd(NetworkDevice.InfoType.Parent):
		print(dev.get_parent())
	
	for child in dev.get_children():
		render(child)
