extends Node



func _ready():
	get_parent().add_command_module($Console)
	get_parent().add_command_module($Network)

### Console module
func on_command_cls(console, _args):
	console.clear_output()

func on_command_echo(console, args):
	console.push_message(args[0])

func on_command_help(console, _args):
	var msg = "----HELP------------------------------------\n"
	msg += "Using the console: \n"
	msg += "	Enter a command followed by space-separated arguments.\n"
	
	for module in console.command_modules:
		msg += module.generate_help_string()
	
	console.push_message(msg)

### Network module
func on_command_ping(console, args):
	if not console.current_port:
		console.push_message("Not connected to a network")
		return
	
	var result = console.current_port.network_manager.ping(args[0], console.current_port.address)
	console.push_message(result)
	
func on_command_traceroute(console, args):
	if not console.current_port:
		console.push_message("Not connected to a network")
		return
	
	var result = console.current_port.network_manager.traceroute(args[0], console.current_port.address)
	if result is String:
		console.push_message(result)
		return
	for line in result:
		console.push_message(line)
		
