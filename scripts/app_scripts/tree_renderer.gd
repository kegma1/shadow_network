extends Node2D

@onready var top_layer = $HBoxContainer
@export var spaceing: int = 15

var explorer_node: PackedScene = load("res://sceans/explorer_node.tscn")

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
		render(current_subnet)

	cyberdeck.connect_to_port.connect(_on_connect_to_port)
	cyberdeck.disconnect_from_port.connect(_on_disconnect_from_port)
	network_manager.tree_updated.connect(_rerender)
	
	

func _rerender():
	if current_subnet:
		for c in top_layer.get_children():
			c.queue_free()
		render(current_subnet)
	
func _on_connect_to_port(port):
	# may change this later if vpns or simiular gets added 🤷‍♂️
	if current_port:
		return
	
	current_port = port
	current_subnet = network_manager.get_subnet_device(current_port.address)
	assert(current_port, "there is something wrong with the network")
	for c in top_layer.get_children():
		c.queue_free()
	render(current_subnet)
	
	
func _on_disconnect_from_port():
	if current_port:
		pass
	current_port = null

func render(dev:NetworkDevice, parent_dictionary = {}):
	var info = dev.get_discoverd_info()
	
	var new_node: Control = explorer_node.instantiate()
	new_node.spaceing = spaceing
	if info:
		
		if "hostname" in info: new_node.hostname = info["hostname"]
		if "address" in info: new_node.address = info["address"]
		if "type" in info: new_node.type = info["type"]

		if "parent" in info:
			var parent_node = parent_dictionary[info["parent"]]
			assert(parent_node, "idk, the parent should always exist")
			
			parent_node.append_node(new_node)
		else:
			top_layer.add_child(new_node)
	parent_dictionary[dev] = new_node
	$HBoxContainer.add_theme_constant_override("separation", new_node.width + spaceing)
	
	for child in dev.get_children():
		render(child, parent_dictionary)
