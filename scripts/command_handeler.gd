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

# "Reply from %s: bytes=32 time=%sms TTL=60" % [dest_address, randi_range(1, 59)]
### Network module
func on_command_ping(console, args):
	if not console.current_port:
		console.push_message("Not connected to a network")
		return
	
	var result = console.current_port.network_manager.ping(args[0], console.current_port.address)
	if result:
		console.push_message("Reply from %s: bytes=32 time=%sms TTL=60" % [args[0], randi_range(1, 59)])
		return
		
	console.push_message("Ping request could not find host %s" % args[0])
	
func on_command_traceroute(console, args):
	if not console.current_port:
		console.push_message("Not connected to a network")
		return
	
	var result = console.current_port.network_manager.traceroute(args[0], console.current_port.address)
	if result:
		console.push_message("Tracing route to %s" % args[0])
		console.push_message("Step\tAddress")
		
		for i in range(result.size()):
			console.push_message("%0*d\t%s" % [4,i + 1, result[i].address])
		return
		
	console.push_message("Failed to find host %s" % args[0])
	
	
		

